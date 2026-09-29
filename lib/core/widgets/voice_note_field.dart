import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../app/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/auth_providers.dart' show backendDataEnabledProvider;
import '../../shared/providers/backend_providers.dart';

/// Voice-to-text for notes (2026-09-27) — kitchens are a bad typing
/// environment (gloved/wet hands, an angled tablet); this lets staff
/// dictate a note instead. The ENTIRE integration surface for a caller is
/// dropping this into an existing TextField's `suffixIcon`:
///
///   TextField(
///     controller: notesController,
///     decoration: InputDecoration(
///       labelText: 'Notes',
///       suffixIcon: VoiceNoteMicButton(controller: notesController),
///     ),
///   ),
///
/// This widget never owns note text — it only ever mutates the caller's
/// existing [TextEditingController], splicing transcribed text in at the
/// current cursor/selection position (like a paste), never overwriting
/// whatever the caller already typed. That is what makes the agreed
/// safeguard concrete: transcribed text always lands as plain, editable
/// text, and nothing in this widget ever calls a submit/save path — it
/// touches the controller and nothing else.
///
/// Recording is capped at [_maxRecordingSeconds] (60s) — a "note" is a
/// short annotation in every field this is used on, not a dictaphone;
/// hitting the cap auto-stops and transcribes whatever was captured, it
/// never discards a recording.
class VoiceNoteMicButton extends ConsumerStatefulWidget {
  const VoiceNoteMicButton({required this.controller, this.onError, super.key});

  /// The SAME controller the caller's TextField already uses.
  final TextEditingController controller;

  /// Optional hook for a caller-specific error surface (e.g. a SnackBar).
  /// This widget always shows its own inline error regardless.
  final void Function(String message)? onError;

  @override
  ConsumerState<VoiceNoteMicButton> createState() => _VoiceNoteMicButtonState();
}

enum _VoiceNoteState { idle, recording, transcribing, error }

const _maxRecordingSeconds = 60;

class _VoiceNoteMicButtonState extends ConsumerState<VoiceNoteMicButton> {
  final _recorder = AudioRecorder();
  _VoiceNoteState _state = _VoiceNoteState.idle;
  String? _errorMessage;
  Timer? _timer;
  int _elapsedSeconds = 0;
  String? _recordingPath;

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    final hasPermission = await _recorder.hasPermission();
    if (!mounted) return;
    if (!hasPermission) {
      _showError(AppLocalizations.of(context)!.microphonePermissionDenied);
      return;
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _recorder.start(const RecordConfig(encoder: AudioEncoder.wav), path: path);
    if (!mounted) return;
    setState(() {
      _state = _VoiceNoteState.recording;
      _recordingPath = path;
      _elapsedSeconds = 0;
      _errorMessage = null;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _elapsedSeconds++);
      if (_elapsedSeconds >= _maxRecordingSeconds) {
        _stopAndTranscribe();
      }
    });
  }

  Future<void> _stopAndTranscribe() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    if (!mounted) return;
    setState(() => _state = _VoiceNoteState.transcribing);

    final filePath = path ?? _recordingPath;
    if (filePath == null) {
      _showError(AppLocalizations.of(context)!.couldntRecordTryAgain);
      return;
    }

    final file = File(filePath);
    try {
      final client = ref.read(backendRestClientProvider);
      final response = await client.uploadAudioForTranscription(
        'transcribe-audio',
        file,
      );
      if (!mounted) return;

      final outcome = response['outcome'] as String?;
      final text = response['text'] as String?;
      if (outcome == 'transcribed' && text != null && text.trim().isNotEmpty) {
        _insertAtCursor(text.trim());
        setState(() => _state = _VoiceNoteState.idle);
      } else {
        _showError(
          (response['error'] as String?) ??
              AppLocalizations.of(context)!.couldntTranscribe,
        );
      }
    } catch (_) {
      if (!mounted) return;
      _showError(AppLocalizations.of(context)!.couldntReachTranscriptionService);
    } finally {
      // Never leave the recorded clip on disk, success or failure.
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  void _insertAtCursor(String text) {
    final controller = widget.controller;
    final selection = controller.selection;
    final oldText = controller.text;

    // A fresh field (no prior selection set) has an invalid/collapsed
    // selection at -1 -- fall back to appending at the end rather than
    // inserting at a nonsensical position.
    final insertAt = selection.isValid ? selection.start : oldText.length;
    final insertEnd = selection.isValid ? selection.end : oldText.length;

    final newText = oldText.replaceRange(insertAt, insertEnd, text);
    controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: insertAt + text.length),
    );
  }

  void _showError(String message) {
    setState(() {
      _state = _VoiceNoteState.error;
      _errorMessage = message;
    });
    widget.onError?.call(message);
    // Return to idle shortly after -- an error here should never leave a
    // note field permanently stuck in a special state.
    Timer(const Duration(seconds: 3), () {
      if (mounted && _state == _VoiceNoteState.error) {
        setState(() => _state = _VoiceNoteState.idle);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // A local/demo-only install has no real account or connection at all
    // (same reasoning SubscriptionRepository's own doc comment gives for
    // billing) — voice transcription genuinely cannot work there, so the
    // icon is hidden entirely rather than shown and left to fail with a
    // confusing "sign in first" the moment someone taps it.
    if (!ref.watch(backendDataEnabledProvider)) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;

    switch (_state) {
      case _VoiceNoteState.idle:
        return IconButton(
          icon: const Icon(Icons.mic_none),
          tooltip: l10n.dictateANote,
          onPressed: _start,
        );
      case _VoiceNoteState.recording:
        final remaining = _maxRecordingSeconds - _elapsedSeconds;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '0:${_elapsedSeconds.toString().padLeft(2, '0')} / '
              '0:${_maxRecordingSeconds.toString().padLeft(2, '0')}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
            ),
            IconButton(
              icon: Icon(Icons.stop_circle, color: AppColors.pass),
              tooltip: remaining <= 10
                  ? l10n.stoppingSoonTapToStop
                  : l10n.stopLabel,
              onPressed: _stopAndTranscribe,
            ),
          ],
        );
      case _VoiceNoteState.transcribing:
        return const Padding(
          padding: EdgeInsets.all(12),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      case _VoiceNoteState.error:
        return Tooltip(
          message: _errorMessage ?? l10n.somethingWentWrong,
          child: const Icon(Icons.mic_off, color: AppColors.critical),
        );
    }
  }
}
