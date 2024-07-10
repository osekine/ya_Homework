import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:to_do_app/core/models/chore.dart';
import 'package:to_do_app/features/manage_chores/data/i_data_source.dart';
import 'package:to_do_app/generated/l10n.dart';
import 'package:to_do_app/main.dart';

import '../test/unit_tests/mock_behavior/mock_local_behavior.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('delete chore on swipe ', (WidgetTester tester) async {
    //arrange
    final mockStorage = GetIt.I.registerSingleton<LocalStorageProxy<Chore>>(
      MockLocalStorageProxy<Chore>(),
    ) as MockLocalStorageProxy<Chore>;
    final mockBehavior = MockLocalBehavior<Chore>(
      mockStorage: mockStorage,
    )
      ..onLoad()
      ..onSave();

    final client =
        GetIt.I.registerSingleton<IDataSource<Chore>>(LocalDataSource<Chore>())
          ..add(Chore(name: 'mocker'))
          ..add(Chore(name: 'reckom'));

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('mocker'), findsOneWidget);
    expect(find.text('reckom'), findsOneWidget);

    //act
    await tester.drag(find.text('mocker'), const Offset(-300, 0));
    await tester.pumpAndSettle();

    //assert
    expect(find.text('mocker'), findsNothing);
    expect(find.text('reckom'), findsOneWidget);
  });

  testWidgets('create new chore', (WidgetTester tester) async {
    //arrange
    final mockStorage = GetIt.I.registerSingleton<LocalStorageProxy<Chore>>(
      MockLocalStorageProxy<Chore>(),
    ) as MockLocalStorageProxy<Chore>;
    final mockBehavior = MockLocalBehavior<Chore>(
      mockStorage: mockStorage,
    )
      ..onLoad()
      ..onSave();

    final client = GetIt.I
        .registerSingleton<IDataSource<Chore>>(LocalDataSource<Chore>())
      ..add(Chore(name: 'mocker'));

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('mocker'), findsOneWidget);

    //act
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('description')), 'reckom');
    await tester.pump();
    await tester.tap(find.text(S.current.save.toUpperCase()));
    await tester.pumpAndSettle();

    //assert
    expect(find.text('mocker'), findsOneWidget);
    expect(find.text('reckom'), findsOneWidget);
  });
}
