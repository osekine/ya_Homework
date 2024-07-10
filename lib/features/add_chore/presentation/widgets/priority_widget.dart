part of '../screens/new_chore.dart';

class PriorityWidget extends StatelessWidget {
  const PriorityWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return DropdownMenu(
      onSelected: (value) =>
          AddChoreProvider.of(context).changePriority(value ?? Priority.none),
      label: Text(S.of(context).importance),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        labelStyle: TextOption.getCustomStyle(
          style: TextStyles.subtitle,
          color: colors.onBackground,
        ),
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
        return DropdownMenuEntry(value: e, label: e.name);
      }).toList(),
    );
  }
}
