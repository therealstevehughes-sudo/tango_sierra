import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/login_screen.dart';
import '../features/dashboard/top_screen.dart';
import '../features/manager/manager_screen.dart';
import '../features/tasks/task_screen.dart';
import '../shared/models/user.dart';
import '../shared/providers/auth_providers.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    // Five tiers (Sprint 027) map onto the three existing UI surfaces —
    // no new dashboards built this sprint. Executive/Regional share
    // TopScreen (company-wide oversight); Supervisor/VenueManager share
    // ManagerScreen (day-to-day venue management); Base gets the carousel.
    Widget home;
    if (currentUser == null) {
      home = const LoginScreen();
    } else if (currentUser.roleTier == RoleTier.executive ||
        currentUser.roleTier == RoleTier.regional) {
      home = const TopScreen();
    } else if (currentUser.roleTier == RoleTier.venueManager ||
        currentUser.roleTier == RoleTier.supervisor) {
      home = const ManagerScreen();
    } else {
      home = const TaskScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitchen Control',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: home,
      routes: {'/manager': (_) => const ManagerScreen()},
    );
  }
}
