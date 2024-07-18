part of '../screens/home.dart';

class ChoreListBodyWidget extends StatelessWidget {
  const ChoreListBodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = ChoreListProvider.of(context);
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      sliver: DecoratedSliver(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => index < provider.choreList.length
                ? ChoreWidget(provider.choreList[index])
                : GestureDetector(
                    onTap: () async {
                      await context.push('/new');
                      provider.refresh();
                    },
                    child: ListTile(
                      leading: const SizedBox(width: 0, height: 0),
                      title: Text(S.of(context).newChore),
                    ),
                  ),
            childCount: provider.choreList.length + 1,
          ),
        ),
      ),
    );
  }
}
