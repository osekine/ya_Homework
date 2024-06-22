import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:to_do_app/constants/themes.dart';
import 'package:to_do_app/features/manage_chores/presentation/screens/home.dart';

void main() {
  final log = Logger(
    printer: PrettyPrinter(),
    level: Level.debug,
  );
  log.d('App started');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do App',
      theme: darkTheme,
      home: const HomeScreen(),
    );
  }
}
