import 'package:flutter/material.dart';
import 'package:to_do_app/constants/text.dart';
import 'package:to_do_app/features/add_chore/domain/add_chore_provider.dart';
import 'package:to_do_app/generated/l10n.dart';
import 'package:to_do_app/models/chore.dart';
import 'package:to_do_app/utils/format.dart';
import 'package:to_do_app/utils/logs.dart';

part '../widgets/chose_date_widget.dart';
part '../widgets/description_widget.dart';
part '../widgets/priority_widget.dart';
part '../widgets/delete_description_widget.dart';

class NewChoreScreen extends StatefulWidget {
  const NewChoreScreen({super.key});

  @override
  State<NewChoreScreen> createState() => _NewChoreScreenState();
}

class _NewChoreScreenState extends State<NewChoreScreen> {
  final textController = TextEditingController();

  //Нужно для блокировки выбора приоритета, даты и удаления,
  //если TextField пустой (пока работает только для даты)

  //TODO: доделать, уже 4 утра, сил моих нет на это
  bool hasChore = false;

  DateTime? dateTime;
  Priority priority = Priority.none;

  void changeDate(DateTime? newDate) {
    dateTime = newDate;
  }

  void changePriority(Priority newPriority) {
    priority = newPriority;
  }

  void toggleScreen() {
    textController.text.isNotEmpty
        ? setState(() {
            Logs.log('Started chore');
            hasChore = true;
          })
        : setState(() {
            Logs.log('Clear chore');
            hasChore = false;
          });
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(toggleScreen);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AddChoreProvider(
      changePriority: changePriority,
      changeDate: changeDate,
      hasChore: hasChore,
      textController: textController,
      child: Scaffold(
        appBar: AppBar(
          elevation: 8,
          forceMaterialTransparency: true,
          surfaceTintColor: colors.surface,
          shadowColor: colors.shadow,
          backgroundColor: colors.background,
          foregroundColor: colors.onBackground,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Logs.log('Poped to HomeScreen');
              Navigator.maybePop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Logs.log('Saved chore');
                Chore? newChore;
                if (hasChore) {
                  newChore = Chore(
                    name: textController.text,
                    deadline: dateTime,
                    priority: priority,
                  );
                }
                Navigator.maybePop<Chore?>(context, newChore);
              },
              child: Text(
                S.of(context).save.toUpperCase(),
                style: TextOption.getCustomStyle(
                  style: TextStyles.button,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: ListView(
            children: [
              const DescriptionWidget(),
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: PriorityWidget(),
              ),
              Divider(color: colors.onSurface),
              const ChoseDateWidget(),
              Divider(color: colors.onSurface),
              const DeleteDescriptionWidget(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
