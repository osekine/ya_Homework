import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app/core/constants/themes.dart';
import 'package:to_do_app/features/add_chore/presentation/screens/new_chore.dart';
import 'package:to_do_app/features/manage_chores/data/i_data_source.dart';
import 'package:to_do_app/features/manage_chores/presentation/screens/home.dart';
import 'package:to_do_app/core/models/chore.dart';
import 'package:to_do_app/features/manage_chores/data/client.dart';
import 'package:to_do_app/core/utils/logs.dart';

import 'generated/l10n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  GetIt.I.registerSingleton<LocalStorageProxy<Chore>>(
    SharedPreferncesProxy<Chore>(),
  );
  GetIt.I.registerSingleton<NetworkStorageProxy<Chore>>(DioProxy<Chore>());
  GetIt.I.registerSingleton<IDataSource<Chore>>(ClientModel<Chore>());

  Logs.log('App started');
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'details/:choreId',
          builder: (context, state) =>
              NewChoreScreen(choreId: state.pathParameters['choreId']),
          redirect: (context, state) =>
              '/details/${state.pathParameters['choreId']}',
        ),
        GoRoute(
          path: 'new',
          builder: (context, state) => const NewChoreScreen(),
          redirect: (context, state) => '/new',
        ),
      ],
    ),
  ],
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
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
      // home: FutureBuilder(
      //   future: model.getData(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) return const HomeScreen();
      //     return const Center(child: CircularProgressIndicator());
      //   },
      // ),
    );
  }
}
