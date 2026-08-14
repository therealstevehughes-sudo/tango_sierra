import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/login_screen.dart';
import '../features/home/tier_home_screen.dart';
import '../features/tasks/task_screen.dart';
import '../shared/models/user.dart';
import '../shared/providers/auth_providers.dart';
import 'theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    // Tier home screen (Sprint 031, Build Order item 5, Sub-sprint A):
    // every non-base tier now lands on TierHomeScreen (My Tasks /
    // Oversight), not straight on ManagerScreen/TopScreen — closes the
    // gap where a task tiered above base could be assigned but never
    // reached. base is unchanged: straight to the carousel, no home menu,
    // per the Staff Task Screen Rule's minimalism.
    Widget home;
    if (currentUser == null) {
      home = const LoginScreen();
    } else if (currentUser.roleTier == RoleTier.base) {
      home = const TaskScreen();
    } else {
      home = const TierHomeScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitchen Control',
      theme: AppTheme.light,
      home: home,
    );
  }
}
