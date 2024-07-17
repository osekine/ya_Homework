import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:to_do_app/core/models/chore.dart';
import 'package:to_do_app/core/utils/logs.dart';
import 'package:to_do_app/features/manage_chores/data/i_data_source.dart';

class MockNetworkStorageProxy<T> extends Mock
    implements NetworkStorageProxy<T> {
  List<T>? list;
  @override
  int revision = 0;
}

class MockNetworkBehavior<T extends Chore> {
  MockNetworkBehavior({required this.mockStorage, this.connection});
  final MockNetworkStorageProxy<T> mockStorage;
  bool? connection;

  void onLoad() {
    return when(() => mockStorage.load()).thenAnswer((_) async {
      if (connection ?? false) {
      } else {
        Logs.elog('No connection');
      }
      return Future.value(mockStorage.list);
    });
  }

  void onSave() {
    return when(
      () => mockStorage.save(
        any(that: isA<T>()),
      ),
    ).thenAnswer((i) async {
      if (connection ?? false) {
        mockStorage.list?.add(i.positionalArguments[0] as T);
        mockStorage
          ..list ??= [i.positionalArguments[0] as T]
          ..revision += 1;
      } else {
        Logs.elog('No connection');
        return false;
      }
      return true;
    });
  }

  void onDelete() {
    return when(() => mockStorage.delete(any(that: isA<String>())))
        .thenAnswer((i) async {
      if (connection ?? false) {
        mockStorage
          ..list?.remove(
            Chore(name: 'mocker', id: i.positionalArguments[0] as String),
          )
          ..revision += 1;
      } else {
        Logs.elog('No connection');
      }
    });
  }

  void onUpdate() {
    return when(
      () => mockStorage.update(
        any(that: isA<T>()),
        any(that: isA<String>()),
      ),
    ).thenAnswer((i) async {
      if (connection ?? false) {
        mockStorage.list
          ?..removeWhere(
            (element) => element.id == i.positionalArguments[1] as String,
          )
          ..add(i.positionalArguments[0] as T);
        mockStorage.revision += 1;
      } else {
        Logs.elog('No connection');
      }
    });
  }

  void onSync() {
    return when(() => mockStorage.syncronize(any(that: isA<List<T>>())))
        .thenAnswer((i) async {
      if (connection ?? false) {
        mockStorage
          ..list = i.positionalArguments[0] as List<T>
          ..revision += 1;
      } else {
        Logs.elog('No connection');
      }
    });
  }
}
