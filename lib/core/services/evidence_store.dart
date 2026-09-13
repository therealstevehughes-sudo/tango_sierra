import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Evidence store — real photo capture + durable on-disk persistence.
///
/// Sprint 032 P0 (approved 2026-09-13, PHOTO_EVIDENCE_PLAN.md). Turns the
/// fake `_photoTaken` boolean into REAL evidence: pick a real photo
/// (camera first — strict anti-fraud, the "harder to fake than paper"
/// promise — with an explicit gallery fallback so a worker can attach an
/// existing photo for checks that allow it), copy the JPEG bytes into
/// `<app documents>/evidence/`, and return a stable path.
///
/// Why files on disk instead of a BLOB in Drift — your exact "space-heavy
/// over time" concern, answered at the storage layer:
///   * JPEG bytes are ~10–50 KB (image_picker's own camera output), not
///     2–5 MB PNG. A real capture is space-efficient by construction.
///   * A `photoPath` String reference rides in the existing Drift column —
///     zero model change, zero BLOB bloat in every query/backup.
///   * Backups/sync stay lean (path, not megabytes); the EHO PDF embeds
///     the actual bytes so an inspector sees real evidence, not a marker.
///
/// Space-stewardship caveat (honest, per DRIFT_GUARD / DESIGN_SYSTEM_LOCK):
/// this store ADDS evidence. "Free up space / prune old evidence" is a
/// separate P1 tool, deliberately deferred — this sprint never claims to
/// reclaim space it doesn't.
class EvidenceStore {
  /// Picks a photo from the device (camera preferred; gallery fallback),
  /// copies the bytes into the app's evidence dir, and returns the stable
  /// path. Returns null if the user cancels or capture fails — never
  /// throws on a cancel.
  Future<String?> pickAndPersistPhoto() async {
    final file = await _pickFromSource(ImageSource.camera);
    if (file != null) return _persist(file);
    // Camera unavailable or declined — offer the gallery as the explicit
    // fallback (per the approved "camera first, gallery to follow"
    // decision in PHOTO_EVIDENCE_PLAN.md).
    final galleryFile = await _pickFromSource(ImageSource.gallery);
    if (galleryFile != null) return _persist(galleryFile);
    return null;
  }

  Future<String?> pickFromGallery() async {
    final file = await _pickFromSource(ImageSource.gallery);
    if (file == null) return null;
    return _persist(file);
  }

  Future<XFile?> _pickFromSource(ImageSource source) async {
    try {
      final picker = ImagePicker();
      return picker.pickImage(source: source, imageQuality: 62);
    } on Exception {
      return null;
    }
  }

  Future<String> _persist(XFile file) async {
    final dir = await _evidenceDir();
    // Globally-unique, sort-stable name: two captures can never collide,
    // and the export can list them in capture order.
    final name =
        '${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}';
    final dest = p.join(dir.path, name);
    await File(file.path).copy(dest);
    return dest;
  }

  /// Lazily-created `<app documents>/evidence/`. All evidence lives under
  /// this one directory so an inspector-facing export + a future backup
  /// both know exactly where real evidence is, and so "prune old evidence"
  /// (deferred P1) has one place to walk.
  Future<Directory> _evidenceDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'evidence'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// Reads the bytes of a persisted evidence photo. Returns null (never
  /// throws) if the file is missing or unreadable — the PDF export handles
  /// a gracefully-degraded "marker only" fallback.
  Future<List<int>?> readPhotoBytes(String path) async {
    final file = File(path);
    if (!await file.exists()) return null;
    try {
      return await file.readAsBytes();
    } catch (_) {
      return null;
    }
  }

  /// Lists this device's persisted evidence photos (a `List<FileSystemEntity>`)
  /// in the app's evidence dir. Returns an empty list (never throws) if the
  /// dir doesn't exist yet.
  Future<List<FileSystemEntity>> listEvidenceFiles() async {
    final dir = await _evidenceDir();
    try {
      return await dir.list().toList();
    } catch (_) {
      return const [];
    }
  }

  /// The total size (bytes) of every file under the evidence dir, for the
  /// "free up space" tally a prune manager needs before it deletes anything.
  Future<int> evidenceTotalBytes() async {
    final files = await listEvidenceFiles();
    var total = 0;
    for (final entity in files) {
      if (entity is File) {
        try {
          total += await entity.length();
        } catch (_) {}
      }
    }
    return total;
  }

  /// Deletes persisted evidence photos. Returns the count actually deleted.
  /// Never throws — a file already gone just isn't counted.
  Future<int> deleteEvidenceFiles(List<FileSystemEntity> files) async {
    var deleted = 0;
    for (final entity in files) {
      if (entity is! File) continue;
      try {
        if (await entity.exists()) {
          await entity.delete();
          deleted++;
        }
      } catch (_) {}
    }
    return deleted;
  }
}

final evidenceStoreProvider = Provider<EvidenceStore>((ref) => EvidenceStore());
