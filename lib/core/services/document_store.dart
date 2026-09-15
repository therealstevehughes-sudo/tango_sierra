import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Document Centre's file store (roadmap v1.1, built 2026-09-15) — same
/// "copy into this app's own storage, never reference the original pick
/// location" pattern as [EvidenceStore] and `SettingsScreen._pickLogo`:
/// the source (a USB drive, a network share, a Downloads folder) could
/// be renamed or disconnected later, which would silently break the
/// document link.
class DocumentStore {
  /// Lets the user pick any file (PDF, Word doc, image scan of a
  /// certificate, etc — no type restriction, since a policy/cert/EHO
  /// report can arrive in any of those forms) and copies it into
  /// `<app documents>/documents/`. Returns null on cancel — never throws.
  Future<String?> pickAndPersist() async {
    final result = await FilePicker.platform.pickFiles();
    final pickedPath = result?.files.single.path;
    if (pickedPath == null) return null;

    final dir = await _documentsDir();
    final name =
        '${DateTime.now().millisecondsSinceEpoch}_${p.basename(pickedPath)}';
    final dest = p.join(dir.path, name);
    await File(pickedPath).copy(dest);
    return dest;
  }

  Future<Directory> _documentsDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'documents'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }
}

final documentStoreProvider = Provider<DocumentStore>((ref) => DocumentStore());
