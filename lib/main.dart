import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:to_do_app/constants/themes.dart';
import 'package:to_do_app/features/manage_chores/presentation/screens/home.dart';
import 'package:to_do_app/models/chore.dart';
import 'package:to_do_app/features/manage_chores/data/client.dart';
import 'package:to_do_app/utils/logs.dart';

import 'generated/l10n.dart';

void main() {
  Logs.log('App started');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ClientModel<Chore> model;

  @override
  void initState() {
    super.initState();
    model = ClientModel<Chore>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'To Do App',
      theme: darkTheme,
      home: FutureBuilder(
        future: model.getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) return HomeScreen(model: model);
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
