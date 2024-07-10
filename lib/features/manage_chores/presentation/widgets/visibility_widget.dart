import 'package:flutter/material.dart';
import 'package:to_do_app/features/manage_chores/domain/chore_list_provider.dart';

class VisibilityWidget extends StatelessWidget {
  const VisibilityWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = ChoreListProvider.of(context);
    return GestureDetector(
      onTap: () => provider.onToggleVisible(),
      child: provider.isDoneVisible
          ? const Icon(Icons.visibility_outlined)
          : const Icon(Icons.visibility_off_outlined),
    );
  }
}
