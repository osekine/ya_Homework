import 'package:flutter/material.dart';
import 'package:to_do_app/models/chore.dart';

class AddChoreProvider extends InheritedWidget {
  const AddChoreProvider({
    super.key,
    required super.child,
    required this.hasChore,
    required this.textController,
    this.date,
    this.priority = Priority.none,
    required this.changeDate,
    required this.changePriority,
  });

  final Function(DateTime) changeDate;
  final Function(Priority) changePriority;
  final bool hasChore;
  final TextEditingController textController;
  final DateTime? date;
  final Priority priority;

  @override
  bool updateShouldNotify(AddChoreProvider oldWidget) {
    return hasChore != oldWidget.hasChore;
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
    return hasChore
        ? Chore(
            name: textController.text,
            deadline: date,
            priority: priority,
          )
        : null;
  }
}
