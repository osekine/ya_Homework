import 'package:flutter/material.dart';

class DeleteDescriptionWidget extends StatelessWidget {
  const DeleteDescriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
        style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            foregroundColor: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero),
        onPressed: () {},
        icon: const Icon(Icons.delete_outline),
        label: const Text('Удалить'));
  }
}
