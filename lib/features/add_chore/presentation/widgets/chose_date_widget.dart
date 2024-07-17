part of '../screens/new_chore.dart';

class ChoseDateWidget extends StatefulWidget {
  const ChoseDateWidget({super.key});

  @override
  State<ChoseDateWidget> createState() => _ChoseDateWidgetState();
}

class _ChoseDateWidgetState extends State<ChoseDateWidget> {
  // DateTime? date;

  // bool canSwitch = false;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   bool newCanSwitch = NewChoreScreenState.of(context).hasChore;
  //   if (newCanSwitch != canSwitch) {
  //     setState(() {
  //       canSwitch = newCanSwitch;
  //       date = NewChoreScreenState.of(context).dateTime;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final canSwitch = AddChoreProvider.chorePresenceOf(context);
    final baseColor = canSwitch ? colors.onBackground : colors.onSurface;
    Logs.log('ChoseDateWidget build');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).deadline,
              style: TextOption.getCustomStyle(
                style: TextStyles.body,
                color: baseColor,
              ),
            ),
            const _DateDescriptionWidget(),
          ],
        ),
        _SwitchDateWidget(baseColor: baseColor, canSwitch: canSwitch),
      ],
    );
  }
}

class _SwitchDateWidget extends StatefulWidget {
  const _SwitchDateWidget({
    required this.baseColor,
    required this.canSwitch,
  });

  final Color baseColor;
  final bool canSwitch;

  @override
  State<_SwitchDateWidget> createState() => _SwitchDateWidgetState();
}

class _SwitchDateWidgetState extends State<_SwitchDateWidget> {
  late NewChoreScreenState controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = NewChoreScreenState.of(context);
  }

  void chooseDate(bool value, DateTime? date) async {
    if (!value) {
      date = null;
    } else {
      final newDate = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1),
      );
      date = newDate;
    }
    controller.changeDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final date = AddChoreProvider.dateOf(context);
    return Switch(
      inactiveThumbColor: widget.baseColor,
      // trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
      //   (Set<WidgetState> states) =>
      //       states.contains(WidgetState.disabled) ||
      //               states.contains(WidgetState.focused)
      //           ? baseColor
      //           : null,
      // ),
      value: date != null && widget.canSwitch,
      onChanged: ((value) => widget.canSwitch ? chooseDate(value, date) : null),
    );
  }
}

class _DateDescriptionWidget extends StatelessWidget {
  const _DateDescriptionWidget();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final date = AddChoreProvider.dateOf(context);
    return date == null
        ? const SizedBox()
        : Text(
            getFormattedDate(date.toLocal()),
            style: TextOption.getCustomStyle(
              style: TextStyles.body,
              color: colors.primary,
            ),
          );
  }
}
