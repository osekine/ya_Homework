import 'package:flutter/material.dart';
import 'package:to_do_app/features/add_chore/presentation/screens/new_chore.dart';
import 'package:to_do_app/core/models/chore.dart';

enum Aspects { hasChore, date, priority }

class AddChoreProvider extends InheritedModel<Aspects> {
  AddChoreProvider({
    super.key,
    required super.child,
    required this.controller,
  })  : hasChore = controller.hasChore,
        dateTime = controller.dateTime,
        priority = controller.priority;

  final NewChoreScreenState controller;
  final bool hasChore;
  final DateTime? dateTime;
  final Priority priority;

  @override
  bool updateShouldNotify(AddChoreProvider oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(
    AddChoreProvider oldWidget,
    Set<Aspects> dependencies,
  ) {
    for (final dep in dependencies) {
      switch (dep) {
        case Aspects.hasChore:
          return hasChore != oldWidget.hasChore;
        case Aspects.date:
          return dateTime != oldWidget.dateTime;
        case Aspects.priority:
          return priority != oldWidget.priority ||
              hasChore != oldWidget.hasChore;
      }
    }
    return false;
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

  static bool chorePresenceOf(BuildContext context) =>
      InheritedModel.inheritFrom<AddChoreProvider>(
        context,
        aspect: Aspects.hasChore,
      )?.hasChore ??
      false;

  static DateTime? dateOf(BuildContext context) =>
      InheritedModel.inheritFrom<AddChoreProvider>(
        context,
        aspect: Aspects.date,
      )?.dateTime;

  static Priority priorityOf(BuildContext context) =>
      InheritedModel.inheritFrom<AddChoreProvider>(
        context,
        aspect: Aspects.priority,
      )?.priority ??
      Priority.none;

  Chore? getChore([String? id]) {
    return controller.hasChore
        ? Chore(
            name: controller.textController.text,
            deadline: controller.dateTime,
            priority: controller.priority,
            id: id,
          )
        : null;
  }
}
