import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:to_do_app/core/models/chore.dart';
import 'package:to_do_app/features/manage_chores/data/i_data_source.dart';

class MockLocalStorageProxy<T> extends Mock implements LocalStorageProxy<T> {
  List<T> list = [];
  int revision = 0;
}

class MockLocalBehavior<T extends Chore> {
  MockLocalBehavior({required this.mockStorage});
  final MockLocalStorageProxy<T> mockStorage;

  void onLoad() {
    when(() => mockStorage.load())
        .thenAnswer((_) async => (mockStorage.revision, mockStorage.list));
  }

  void onSave() {
    when(
      () => mockStorage.save(
        any(that: isA<List<T>>()),
        any(that: isA<int>()),
      ),
    ).thenAnswer((i) async {
      mockStorage
        ..list = i.positionalArguments[0] as List<T>
        ..revision = i.positionalArguments[1] as int;
    });
  }
}
