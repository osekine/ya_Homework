import 'package:flutter/material.dart';
import 'package:to_do_app/constants/text.dart';
import 'package:to_do_app/features/manage_chores/domain/chore_list_provider.dart';
import 'package:to_do_app/utils/format.dart';

import 'package:to_do_app/models/chore.dart';
import 'package:to_do_app/utils/logs.dart';

class ChoreWidget extends StatefulWidget {
  final Chore chore;
  const ChoreWidget(this.chore, {super.key});

  @override
  State<ChoreWidget> createState() => _ChoreWidgetState();
}

class _ChoreWidgetState extends State<ChoreWidget> {
  double offset = 0;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.chore.hashCode),
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.endToStart) {
          Logs.log('${widget.chore.hashCode} deleted');
          ChoreListProvider.of(context)
            ..removeChore(widget.chore)
            ..refresh();
          return Future.value(true);
        } else {
          Logs.log('${widget.chore.hashCode} confirmed');
          widget.chore.isDone = !widget.chore.isDone;
          ChoreListProvider.of(context).updateChore(widget.chore);
          ChoreListProvider.of(context).refresh();
          return Future.value(false);
        }
      },
      onUpdate: (details) {
        offset = details.progress;
        setState(() {});
      },
      dismissThresholds: const {
        DismissDirection.endToStart: 0.2,
        DismissDirection.startToEnd: 0.2,
      },
      background: Container(
        color: Colors.green,
        child: Align(
          alignment: Alignment(((offset / 2 - 1)).clamp(-1, -0.9), 0),
          child: const Icon(Icons.check),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(((1 - offset / 2)).clamp(0.9, 1), 0),
          child: const Icon(Icons.delete_outline),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: widget.chore.isDone
                  ? const Icon(Icons.check_box, color: Colors.green)
                  : Icon(
                      Icons.check_box_outline_blank,
                      color: widget.chore.priority == Priority.high
                          ? Colors.red
                          : Colors.grey,
                    ),
            ),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ChoreTextWidget(chore: widget.chore),
                  if (widget.chore.deadline != null)
                    Text(getFormattedDate(widget.chore.deadline!)),
                ],
              ),
            ),
            const Expanded(flex: 1, child: Icon(Icons.info_outline)),
          ],
        ),
      ),
    );
  }
}

class _ChoreTextWidget extends StatelessWidget {
  const _ChoreTextWidget({required this.chore});
  final Chore chore;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    if (chore.isDone) {
      return Text(
        chore.name,
        style: TextOption.getCustomStyle(
          style: TextStyles.body,
          color: colors.onSurface,
          decoration: TextDecoration.lineThrough,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      );
    }

    switch (chore.priority) {
      case Priority.none:
        return Text(
          chore.name,
          style: TextOption.getCustomStyle(
            style: TextStyles.body,
            color: colors.onBackground,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        );
      case Priority.low:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.arrow_downward_outlined,
            ),
            Expanded(
              child: Text(
                chore.name,
                style: TextOption.getCustomStyle(
                  style: TextStyles.body,
                  color: colors.onBackground,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        );
      case Priority.high:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.priority_high_outlined, color: colors.error),
            Expanded(
              child: Text(
                chore.name,
                style: TextOption.getCustomStyle(
                  style: TextStyles.body,
                  color: colors.onBackground,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ],
        );
    }
  }
}
