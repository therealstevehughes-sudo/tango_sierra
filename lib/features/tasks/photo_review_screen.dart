import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../core/widgets/app_screen_header.dart';
import '../../l10n/app_localizations.dart';

/// Photo check (2026-10-16, direct founder request): after taking or
/// uploading an evidence photo the worker sees it full size and chooses
/// "Use photo" or "Retake" — a blurry or wrong photo is worthless as
/// evidence, and before this there was no preview at all. Pops true for
/// "use", false for "retake".
class PhotoReviewScreen extends StatelessWidget {
  const PhotoReviewScreen({super.key, required this.bytes});

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopScope(
      // Backing out counts as "retake" — never silently keeps a photo the
      // worker didn't confirm.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) Navigator.of(context).pop(false);
      },
      child: Scaffold(
        appBar: AppScreenHeader(title: Text(l10n.photoReviewTitle)),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.photoReviewPrompt,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: InteractiveViewer(
                  maxScale: 5,
                  child: Center(child: Image.memory(bytes)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.replay),
                        label: Text(l10n.retakePhotoButton),
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.check),
                        label: Text(l10n.usePhotoButton),
                        onPressed: () => Navigator.of(context).pop(true),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
