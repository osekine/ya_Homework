import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:to_do_app/core/models/chore.dart';
import 'package:to_do_app/features/manage_chores/data/i_data_source.dart';

void main() {
  late IDataSource<Chore> dataSource;
  late final MockLocalStorageProxy<Chore> mockStorage;
  // int storageRevision = 0;
  // List<Chore> storageList = [];

  setUpAll(
    () {
      registerFallbackValue(Chore(name: 'mocker'));
      mockStorage = GetIt.I.registerSingleton<LocalStorageProxy<Chore>>(
        MockLocalStorageProxy<Chore>(),
      ) as MockLocalStorageProxy<Chore>;
    },
  );

  setUp(() {
    dataSource = LocalDataSource<Chore>()..data = [];
    when(() => mockStorage.load())
        .thenAnswer((_) async => (mockStorage.rev, mockStorage.list));
    when(
      () => mockStorage.save(
        any(that: isA<List<Chore>>()),
        any(that: isA<int>()),
      ),
    ).thenAnswer((i) async {
      mockStorage
        ..list = i.positionalArguments[0] as List<Chore>
        ..rev = i.positionalArguments[1] as int;
    });
  });

  group('Testing local repository', () {
    test('add Chore with right data', () async {
      //arrange
      final chore = Chore(name: 'mocker');

      //act
      dataSource.add(chore);

      //assert

      expect(mockStorage.list, [chore]);
      expect(mockStorage.rev, 1);
    });

    test('get data and revision', () async {
      //arrange

      //act
      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert
      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.rev);
    });

    test('get valid data and revision after saving', () async {
      //arrange
      final chore = Chore(name: 'mocker');
      dataSource.add(chore);

      //act
      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert
      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.rev);
    });

    test('remove Chore', () async {
      //arrange
      final chore = Chore(name: 'mocker');

      //act
      dataSource
        ..add(chore)
        ..remove(chore, chore.id);
      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert
      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.rev);
    });

    test('update Chore', () async {
      //arrange
      final chore = Chore(name: 'mocker');

      //act
      dataSource.add(chore);
      chore.name = 'reckom';
      dataSource.update(chore, chore.id);

      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert
      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.rev);
      expect(mockStorage.list[0].name, 'reckom');
    });

    test('many operations', () async {
      //arrange
      final chore = Chore(name: 'mocker');

      //act
      for (int i = 0; i < 15; ++i) {
        dataSource.add(chore.copyWith(name: 'mocker $i'));
      }

      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert
      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.rev);
      expect(mockStorage.list.length, 15);
    });
  });
}

class MockLocalStorageProxy<T> extends Mock implements LocalStorageProxy<T> {
  List<T> list = [];
  int rev = 0;
}
