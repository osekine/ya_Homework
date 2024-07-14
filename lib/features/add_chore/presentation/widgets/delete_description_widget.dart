part of '../screens/new_chore.dart';

class DeleteDescriptionWidget extends StatelessWidget {
  const DeleteDescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NewChoreScreenState.of(context);
    final isActive = AddChoreProvider.chorePresenceOf(context);
    return TextButton.icon(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        foregroundColor: isActive ? Colors.red : Colors.grey,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.zero,
      ),
      onPressed: () => model.deleteChore(),
      icon: const Icon(Icons.delete_outline),
      label: Text(S.of(context).delete),
    );
  }
}
