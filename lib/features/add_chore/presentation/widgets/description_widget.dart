part of '../screens/new_chore.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: AddChoreProvider.of(context).textController,
      maxLines: null,
      minLines: 5,
      style: TextOption.getCustomStyle(
        style: TextStyles.body,
        color: colors.onBackground,
      ),
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        fillColor: colors.surface,
        hintText: S.of(context).help,
        hintStyle: TextOption.getCustomStyle(
          style: TextStyles.body,
          color: colors.onSurface,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
