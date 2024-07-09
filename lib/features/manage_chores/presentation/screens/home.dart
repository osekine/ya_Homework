import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:to_do_app/features/manage_chores/data/i_data_source.dart';
import 'package:to_do_app/features/manage_chores/presentation/inherits/chore_list_provider.dart';
import 'package:to_do_app/features/add_chore/presentation/screens/new_chore.dart';
import 'package:to_do_app/features/manage_chores/presentation/widgets/chore_title_appbar.dart';
import 'package:to_do_app/features/manage_chores/presentation/widgets/chore.dart';
import 'package:to_do_app/generated/l10n.dart';
import 'package:to_do_app/core/models/chore.dart';
import 'package:to_do_app/features/manage_chores/data/client.dart';
import 'package:to_do_app/core/utils/logs.dart';

part 'package:to_do_app/features/manage_chores/presentation/widgets/chore_list_body_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _controller;
  late final IDataSource<Chore> _model;
  bool isDoneVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _model = GetIt.I<IDataSource<Chore>>();
  }

  void toggleVisible() {
    setState(() {
      isDoneVisible = !isDoneVisible;
      Logs.log('Chores visibility changed to $isDoneVisible');
    });
  }

  void refresh() {
    _model.sync();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChoreListProvider(
      refresh: refresh,
      onToggleVisible: toggleVisible,
      scrollController: _controller,
      client: _model,
      isDoneVisible: isDoneVisible,
      child: Scaffold(
        floatingActionButton: Builder(
          //Билдер нужен для вызова addChore() и синхронизации дел при добавлении через FAB
          builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                Logs.log('Pushed to NewChoreScreen');
                final newChore = await Navigator.of(context).push<Chore?>(
                  MaterialPageRoute(
                    builder: ((context) => const NewChoreScreen()),
                  ),
                );
                Logs.log(newChore?.name ?? 'No new chore');
                if (newChore != null) {
                  setState(() {
                    ChoreListProvider.of(context).addChore(newChore);
                  });
                }
              },
              child: const Icon(Icons.add),
            );
          },
        ),
        body: RefreshIndicator(
          onRefresh: () async => _model.sync(),
          notificationPredicate: (notification) {
            return notification.depth >= 0;
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            slivers: const [
              ChoreTitleAppbar(),
              ChoreListBodyWidget(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
