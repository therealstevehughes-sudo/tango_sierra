import 'package:flutter/material.dart';
import '../features/auth/login_screen.dart';
import '../features/manager/manager_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitchen Control',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
      routes: {'/manager': (_) => const ManagerScreen()},
    );
  }
}
