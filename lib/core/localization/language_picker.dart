import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/providers/auth_providers.dart';
import 'locale_controller.dart';
import 'supported_language.dart';

class LanguageIconButton extends ConsumerWidget {
  const LanguageIconButton({super.key, this.iconColor});

  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return IconButton(
      tooltip: l10n.languageSettingTitle,
      icon: Icon(Icons.language, color: iconColor),
      onPressed: () => showLanguagePicker(context, ref),
    );
  }
}

Future<void> showLanguagePicker(BuildContext context, WidgetRef ref) async {
  final selected = await showModalBottomSheet<SupportedLanguage>(
    context: context,
    showDragHandle: true,
    builder: (context) => const _LanguagePickerSheet(),
  );
  if (selected == null) return;

  final currentUser = ref.read(currentUserProvider);
  if (currentUser == null) {
    await ref
        .read(localeControllerProvider.notifier)
        .setDeviceLocale(selected.locale);
  } else {
    final repo = ref.read(userRepositoryProvider);
    await repo.setPreferredLocale(
      userId: currentUser.id,
      localeCode: selected.storageCode,
    );
    ref.read(currentUserProvider.notifier).state = currentUser.copyWith(
      preferredLocale: selected.storageCode,
    );
    await ref
        .read(localeControllerProvider.notifier)
        .applyUserLocale(selected.storageCode);
  }

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppLocalizations.of(context)!.languageUpdated)),
  );
}

class _LanguagePickerSheet extends ConsumerWidget {
  const _LanguagePickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeControllerProvider);
    final currentUser = ref.watch(currentUserProvider);
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            l10n.chooseLanguageTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            currentUser == null
                ? l10n.languageDeviceScope
                : l10n.languageUserScope(currentUser.name),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          for (final language in supportedLanguages)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(language.displayName),
              trailing: locale.languageCode == language.locale.languageCode
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () => Navigator.pop(context, language),
            ),
        ],
      ),
    );
  }
}
