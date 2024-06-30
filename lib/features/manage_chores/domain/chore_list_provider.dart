import 'package:flutter/material.dart';
import 'package:to_do_app/models/chore.dart';
import 'package:to_do_app/features/manage_chores/data/client.dart';

/*
  Идея: переделать на InheritedModel, сделать три аспекта: title, visibility и list
  list обновляется при добавлении/удалении элемента, изменения выполненности Chore (если !isDoneVisible)
  title обновляется при изменении выполненности и удалении Chore (если выполнен)
  visibility обновляется при изменении состояния isDoneVisible
*/
class ChoreListProvider extends InheritedWidget {
  final ClientModel<Chore> client;
  final bool isDoneVisible;
  final ScrollController scrollController;
  final VoidCallback onToggleVisible;
  final VoidCallback refresh;

  const ChoreListProvider({
    super.key,
    required super.child,
    required this.client,
    required this.isDoneVisible,
    required this.scrollController,
    required this.onToggleVisible,
    required this.refresh,
  });

  @override
  bool updateShouldNotify(ChoreListProvider oldWidget) {
    return true;
    // return isDoneVisible != oldWidget.isDoneVisible ||
    //     client.data?.length !=
    //         oldWidget.client.data?.length; //временная заглушка
  }

  static ChoreListProvider? maybeOf(
    BuildContext context, {
    required bool listen,
  }) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<ChoreListProvider>()
          : context.getInheritedWidgetOfExactType();

  static ChoreListProvider of(BuildContext context) =>
      maybeOf(context, listen: true)!;

  List<Chore> get choreList => isDoneVisible
      ? client.data?.reversed.toList() ?? []
      : client.data?.reversed.where((chore) => !chore.isDone).toList() ?? [];

  int get doneCount => client.data?.where((chore) => chore.isDone).length ?? 0;

  void tryAddScrollListener(VoidCallback listener) =>
      scrollController.hasClients
          ? scrollController.addListener(listener)
          : null;

  void updateChore(Chore chore) => client.update(chore, chore.id);

  void removeChore(Chore chore) => client.remove(chore, chore.id);
}
