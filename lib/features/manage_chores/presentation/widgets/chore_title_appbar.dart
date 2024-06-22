import 'package:flutter/material.dart';
import 'package:to_do_app/constants/text.dart';
import 'package:to_do_app/features/manage_chores/domain/chore_list_provider.dart';

import 'visibility_widget.dart';

class ChoreTitleAppbar extends StatefulWidget {
  const ChoreTitleAppbar({
    super.key,
  });

  @override
  State<ChoreTitleAppbar> createState() => _ChoreTitleAppbarState();
}

class _ChoreTitleAppbarState extends State<ChoreTitleAppbar> {
  @override
  Widget build(BuildContext context) {
    final controller = ChoreListProvider.of(context).scrollController;
    if (!controller.hasListeners) {
      controller.addListener(() {
        if (controller.offset < 100) {
          setState(() {});
        }
      });
    }
    final theme = Theme.of(context);
    return SliverAppBar(
      surfaceTintColor: theme.colorScheme.surface,
      shadowColor: theme.colorScheme.shadow,
      elevation: 16,
      expandedHeight: 100,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(color: theme.colorScheme.background),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.loose,
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Positioned(
                    left: 0,
                    bottom: controller.hasClients
                        ? (20 - controller.offset).clamp(0, 20)
                        : 20,
                    child: Text(
                      'Мои дела',
                      style: TextOption.getCustomStyle(
                          style: TextStyles.title,
                          color: theme.colorScheme.onBackground),
                    ),
                  ),
                  Opacity(
                    opacity: controller.hasClients
                        ? (1 - controller.offset / 10).clamp(0, 1)
                        : 1,
                    child: Text(
                      'Выполнено дел - ${ChoreListProvider.of(context).doneCount}',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(flex: 1, child: VisibilityWidget())
          ],
        ),
      ),
    );
  }
}
