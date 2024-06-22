import 'package:flutter/material.dart';
import 'package:to_do_app/constants/text.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return TextField(
      maxLines: null,
      minLines: 5,
      style: TextOption.getCustomStyle(
          style: TextStyles.body, color: colors.onBackground),
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        fillColor: colors.surface,
        hintText: 'Что надо сделать...',
        hintStyle: TextOption.getCustomStyle(
            style: TextStyles.body, color: colors.onSurface),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
