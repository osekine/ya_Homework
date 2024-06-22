import 'package:flutter/material.dart';
import 'package:to_do_app/constants/text.dart';
import 'package:to_do_app/utils/format.dart';

class ChoseDateWidget extends StatefulWidget {
  const ChoseDateWidget({
    super.key,
  });

  @override
  State<ChoseDateWidget> createState() => _ChoseDateWidgetState();
}

class _ChoseDateWidgetState extends State<ChoseDateWidget> {
  bool dateActive = false;
  DateTime? date;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Сделать до',
                style: TextOption.getCustomStyle(
                    style: TextStyles.body, color: colors.onBackground)),
            if (date != null)
              Text(getFormattedDate(date!.toLocal()),
                  style: TextOption.getCustomStyle(
                      style: TextStyles.body, color: colors.primary)),
          ],
        ),
        Switch(
            value: dateActive,
            onChanged: ((value) async {
              if (!value) {
                date = null;
                dateActive = false;
                setState(() {});
                return;
              }
              dateActive = value;
              final newDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1));
              date = newDate;
              dateActive = date != null;
              setState(() {});
            })),
      ],
    );
  }
}
