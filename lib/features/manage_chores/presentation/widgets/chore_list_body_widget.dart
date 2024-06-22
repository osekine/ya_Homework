import 'package:flutter/material.dart';
import 'package:to_do_app/features/add_chore/presentation/screens/new_chore.dart';
import 'package:to_do_app/features/manage_chores/domain/chore_list_provider.dart';
import 'package:to_do_app/features/manage_chores/presentation/widgets/chore.dart';

class ChoreListBodyWidget extends StatelessWidget {
  const ChoreListBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chores = ChoreListProvider.of(context).choreList;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      sliver: DecoratedSliver(
          decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(16))),
          sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => index < chores.length
                      ? ChoreWidget(chores[index])
                      : GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const NewChoreScreen()))),
                          child: const ListTile(
                              leading: SizedBox(width: 0, height: 0),
                              title: Text(
                                'Новое',
                              )),
                        ),
                  childCount: chores.length + 1))),
    );
  }
}
