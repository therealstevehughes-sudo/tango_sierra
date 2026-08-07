import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/user.dart';
import '../../shared/providers/site_providers.dart';

/// The logged-in person's name (and venue, once resolved) — replaces the
/// developer-facing tier labels ("Manager View", "Top-Tier View", "Task")
/// every screen's `AppBar` previously showed. Shared across all three
/// tiers deliberately (unlike ManagerScreen/TopScreen's usual duplicated
/// widgets) since the pattern is identical everywhere, not screen-specific
/// content. Falls back to the name alone while the site is still resolving
/// or if none exists.
class UserTitle extends ConsumerWidget {
  const UserTitle({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final siteAsync = ref.watch(currentSiteProvider);
    final siteName = siteAsync.maybeWhen(
      data: (site) => site.name,
      orElse: () => null,
    );

    return Text(
      siteName == null ? user.name : '${user.name} · $siteName',
      overflow: TextOverflow.ellipsis,
    );
  }
}
