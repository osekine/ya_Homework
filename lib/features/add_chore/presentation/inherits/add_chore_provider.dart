import 'package:flutter/material.dart';
import 'package:to_do_app/features/add_chore/presentation/screens/new_chore.dart';
import 'package:to_do_app/core/models/chore.dart';

class AddChoreProvider extends InheritedWidget {
  const AddChoreProvider({
    super.key,
    required super.child,
    required this.controller,
  });

  final NewChoreScreenState controller;

  @override
  bool updateShouldNotify(AddChoreProvider oldWidget) {
    return controller.hasChore != oldWidget.controller.hasChore;
  }

  static AddChoreProvider? maybeOf(
    BuildContext context, {
    required bool listen,
  }) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType()
          : context.getInheritedWidgetOfExactType();

  static AddChoreProvider of(BuildContext context) =>
      maybeOf(context, listen: true) as AddChoreProvider;

  Chore? getChore() {
    return controller.hasChore
        ? Chore(
            name: controller.textController.text,
            deadline: controller.dateTime,
            priority: controller.priority,
          )
        : null;
  }
}
