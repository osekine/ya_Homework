part of '../screens/new_chore.dart';

class ChoseDateWidget extends StatefulWidget {
  const ChoseDateWidget({
    super.key,
  });

  @override
  State<ChoseDateWidget> createState() => _ChoseDateWidgetState();
}

class _ChoseDateWidgetState extends State<ChoseDateWidget> {
  DateTime? date;

  bool canSwitch = false;

  void chooseDate(bool value) async {
    if (!value || !canSwitch) {
      setState(() {
        date = null;
      });
      return;
    }
    final newDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    setState(() {
      date = newDate;
      if (date != null) AddChoreProvider.of(context).changeDate(date!);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bool newCanSwitch = AddChoreProvider.of(context).hasChore;
    if (newCanSwitch != canSwitch) {
      canSwitch = newCanSwitch;
      chooseDate(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
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
                color: colors.onBackground,
              ),
            ),
            if (date != null)
              Text(
                getFormattedDate(date!.toLocal()),
                style: TextOption.getCustomStyle(
                  style: TextStyles.body,
                  color: colors.primary,
                ),
              ),
          ],
        ),
        Switch(
          value: date != null && canSwitch,
          onChanged: chooseDate,
        ),
      ],
    );
  }
}
