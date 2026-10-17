import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../navigation/app_menu.dart';
import 'app_card.dart';
import 'app_screen_header.dart';
import 'responsive_content.dart';

/// A menu item that bundles several screens (People, Tasks, Rota…) opens
/// this: one card per part, so the side menu stays short (2026-10-17 menu
/// redesign — see app_menu.dart).
class MenuHubScreen extends StatelessWidget {
  const MenuHubScreen({super.key, required this.title, required this.entries});

  final String title;
  final List<MenuEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppScreenHeader(title: Text(title)),
      body: ResponsiveContent(
        maxWidth: 640,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final e in entries) ...[
              AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(e.icon, color: AppColors.teal),
                  title: Text(
                    e.label,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: e.subtitle == null ? null : Text(e.subtitle!),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: e.screen)),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
