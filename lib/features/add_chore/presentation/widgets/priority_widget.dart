import 'package:flutter/material.dart';
import 'package:to_do_app/constants/text.dart';
import 'package:to_do_app/models/chore.dart';

class PriorityWidget extends StatelessWidget {
  const PriorityWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Map<Priority, String> priorityName = {
      Priority.high: 'Высокая',
      Priority.low: 'Низкая',
      Priority.none: 'Нет'
    };
    final colors = Theme.of(context).colorScheme;
    return DropdownMenu(
        label: const Text('Важность'),
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
          labelStyle: TextOption.getCustomStyle(
              style: TextStyles.subtitle, color: colors.onBackground),
        ),
        enableSearch: false,
        menuStyle: MenuStyle(
          surfaceTintColor:
              MaterialStateColor.resolveWith((states) => colors.surface),
          alignment: AlignmentDirectional.topStart,
        ),
        trailingIcon:
            const Icon(Icons.arrow_drop_down, color: Colors.transparent),
        initialSelection: Priority.none,
        dropdownMenuEntries: Priority.values.map((e) {
          if (e == Priority.high) {
            return DropdownMenuEntry(
                value: e,
                label: priorityName[e]!,
                leadingIcon: const Icon(Icons.priority_high),
                style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    iconSize: MaterialStateProperty.all(16),
                    iconColor: MaterialStateProperty.all(Colors.red),
                    foregroundColor: MaterialStateProperty.all(
                      Colors.red,
                    )));
          }
          return DropdownMenuEntry(value: e, label: priorityName[e]!);
        }).toList());
  }
}
