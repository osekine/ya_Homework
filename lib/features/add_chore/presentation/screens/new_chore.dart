import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:to_do_app/core/constants/text.dart';
import 'package:to_do_app/features/add_chore/presentation/inherits/add_chore_provider.dart';
import 'package:to_do_app/features/manage_chores/data/i_data_source.dart';
import 'package:to_do_app/generated/l10n.dart';
import 'package:to_do_app/core/models/chore.dart';
import 'package:to_do_app/core/utils/format.dart';
import 'package:to_do_app/core/utils/logs.dart';

part '../widgets/chose_date_widget.dart';
part '../widgets/description_widget.dart';
part '../widgets/priority_widget.dart';
part '../widgets/delete_description_widget.dart';

class NewChoreScreen extends StatefulWidget {
  const NewChoreScreen({
    super.key,
    this.choreId,
  });

  final String? choreId;

  @override
  State<NewChoreScreen> createState() => NewChoreScreenState();
}

class NewChoreScreenState extends State<NewChoreScreen> {
  final textController = TextEditingController();

  //Нужно для блокировки выбора приоритета, даты и удаления,
  //если TextField пустой (пока работает только для даты)

  //TODO: доделать, уже 4 утра, сил моих нет на это
  bool hasChore = false;

  DateTime? dateTime;
  Priority priority = Priority.none;

  late final Future<Chore?>? _chore;

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

  static NewChoreScreenState of(BuildContext context) {
    return AddChoreProvider.of(context).controller;
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (mounted) {
      final chore = await _chore;
      textController
        ..addListener(toggleScreen)
        ..text = chore?.name ?? '';
      dateTime = chore?.deadline;
      priority = chore?.priority ?? Priority.none;

      hasChore = chore != null;
    }
  }

  @override
  void initState() {
    super.initState();
    _chore = GetIt.I<IDataSource<Chore>>().getItem(widget.choreId);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: _chore,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return AddChoreProvider(
            controller: this,
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
                    context.pop();
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
                          priority: priority ?? Priority.none,
                        );
                      }
                      context.pop<Chore?>(newChore);
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
      },
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
