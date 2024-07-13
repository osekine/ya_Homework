part of '../screens/new_chore.dart';

class PriorityWidget extends StatelessWidget {
  const PriorityWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Logs.log('PriorityWidget build');
    final colors = Theme.of(context).colorScheme;
    final priority = AddChoreProvider.priorityOf(context);
    final canSwitch = AddChoreProvider.chorePresenceOf(context);
    final baseColor = canSwitch ? colors.onBackground : colors.onSurface;
    return DropdownMenu(
      enabled: canSwitch,
      onSelected: (value) =>
          NewChoreScreenState.of(context).changePriority(value ?? priority),
      label: Text(
        S.of(context).importance,
        style: TextOption.getCustomStyle(
          style: TextStyles.subtitle,
          color: baseColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        labelStyle: TextOption.getCustomStyle(
          style: TextStyles.subtitle,
          color: baseColor,
        ),
      ),
      enableSearch: false,
      menuStyle: MenuStyle(
        surfaceTintColor:
            WidgetStateColor.resolveWith((states) => colors.surface),
        alignment: AlignmentDirectional.topStart,
      ),
      trailingIcon:
          const Icon(Icons.arrow_drop_down, color: Colors.transparent),
      initialSelection: priority,
      dropdownMenuEntries: Priority.values.map((e) {
        if (e == Priority.high) {
          return _highPriorityEntry(e);
        }
        return DropdownMenuEntry(value: e, label: e.name);
      }).toList(),
    );
  }

  DropdownMenuEntry<Priority> _highPriorityEntry(Priority e) {
    return DropdownMenuEntry(
      value: e,
      label: e.name,
      leadingIcon: const Icon(Icons.priority_high),
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        iconSize: MaterialStateProperty.all(16),
        iconColor: MaterialStateProperty.all(Colors.red),
        foregroundColor: MaterialStateProperty.all(
          Colors.red,
        ),
      ),
    );
  }
}
