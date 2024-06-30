part of '../screens/new_chore.dart';

class DeleteDescriptionWidget extends StatelessWidget {
  const DeleteDescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = AddChoreProvider.of(context);
    return TextButton.icon(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        foregroundColor: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        model.textController.clear();
      },
      icon: const Icon(Icons.delete_outline),
      label: Text(S.of(context).delete),
    );
  }
}
