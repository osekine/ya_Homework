import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:to_do_app/features/manage_chores/domain/chore_list_provider.dart';
import 'package:to_do_app/models/chore.dart';

import '../../../add_chore/presentation/screens/new_chore.dart';
import '../widgets/chore_list_body_widget.dart';
import '../widgets/chore_title_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _controller;
  bool isDoneVisible = false;
  final log = Logger(
    printer: PrettyPrinter(),
    level: Level.debug,
  );

  void toggleVisible() {
    setState(() {
      isDoneVisible = !isDoneVisible;
      log.d('Chores visibility changed to $isDoneVisible');
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return ChoreListProvider(
      onToggleVisible: toggleVisible,
      scrollController: _controller,
      chores: dumbell,
      isDoneVisible: isDoneVisible,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              log.d('Pushed to NewChoreScreen');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: ((context) => const NewChoreScreen())));
            },
            child: const Icon(Icons.add),
          ),
          body: CustomScrollView(controller: _controller, slivers: const [
            ChoreTitleAppbar(),
            ChoreListBodyWidget(),
          ])),
    );
  }
}
