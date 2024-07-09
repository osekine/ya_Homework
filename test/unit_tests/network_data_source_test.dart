import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:to_do_app/core/models/chore.dart';
import 'package:to_do_app/core/utils/logs.dart';
import 'package:to_do_app/features/manage_chores/data/i_data_source.dart';

void main() {
  late IDataSource<Chore> dataSource;
  late final MockNetworkStorageProxy<Chore> mockStorage;
  bool? connection;

  setUpAll(() {
    registerFallbackValue(Chore(name: 'mocker'));
    mockStorage = GetIt.I.registerSingleton<NetworkStorageProxy<Chore>>(
      MockNetworkStorageProxy<Chore>(),
    ) as MockNetworkStorageProxy<Chore>;
  });

  setUp(() {
    dataSource = NetworkDataSource<Chore>()..data = [];
    mockStorage
      ..list = []
      ..revision = 0;

    when(() => mockStorage.load()).thenAnswer((_) async {
      if (connection ?? false) {
      } else {
        Logs.elog('No connection');
      }
      return mockStorage.list;
    });

    when(
      () => mockStorage.save(
        any(that: isA<Chore>()),
      ),
    ).thenAnswer((i) async {
      if (connection ?? false) {
        mockStorage
          ..list.add(i.positionalArguments[0] as Chore)
          ..revision += 1;
      } else {
        Logs.elog('No connection');
        return false;
      }
      return true;
    });

    when(() => mockStorage.delete(any(that: isA<String>())))
        .thenAnswer((i) async {
      if (connection ?? false) {
        mockStorage
          ..list.remove(
              Chore(name: 'mocker', id: i.positionalArguments[0] as String))
          ..revision += 1;
      } else {
        Logs.elog('No connection');
      }
    });

    when(
      () => mockStorage.update(
        any(that: isA<Chore>()),
        any(that: isA<String>()),
      ),
    ).thenAnswer((i) async {
      if (connection ?? false) {
        mockStorage.list
          ..removeWhere(
            (element) => element.id == i.positionalArguments[1] as String,
          )
          ..add(i.positionalArguments[0] as Chore);
        mockStorage.revision += 1;
      } else {
        Logs.elog('No connection');
      }
    });

    when(() => mockStorage.syncronize(any(that: isA<List<Chore>>())))
        .thenAnswer((i) async {
      if (connection ?? false) {
        mockStorage
          ..list = i.positionalArguments[0] as List<Chore>
          ..revision += 1;
      } else {
        Logs.elog('No connection');
      }
    });
  });

  group('Testing network repository', () {
    test('save data to Network', () async {
      //arrange
      connection = true;
      final chore = Chore(name: 'mocker');

      //act
      dataSource.add(chore);

      //assert
      expect(mockStorage.list, [chore]);
      expect(mockStorage.revision, 1);
    });

    test('load data from Network', () async {
      //arrange
      connection = true;

      //act
      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert

      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.revision);
    });

    test('get valid data and revision after saving', () async {
      //arrange
      connection = true;
      final chore = Chore(name: 'mocker');
      dataSource.add(chore);

      //act
      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert
      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.revision);
    });

    test('remove Chore', () async {
      //arrange
      connection = true;
      final chore = Chore(name: 'mocker');

      //act
      dataSource
        ..add(chore)
        ..remove(chore, chore.id);
      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert
      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.revision);
    });

    test('update Chore', () async {
      //arrange
      connection = true;
      final chore = Chore(name: 'mocker');
      final expectedChore = chore.copyWith(name: 'reckom');

      //act
      dataSource
        ..add(chore)
        ..update(expectedChore, chore.id);
      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert
      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.revision);
      expect(mockStorage.list.first.name, expectedChore.name);
    });

    test('syncronize after losing connection', () async {
      //arrange
      connection = false;
      final chore = Chore(name: 'mocker');

      //act
      dataSource.add(chore);
      connection = true;
      dataSource.sync();

      //assert
      expect(mockStorage.list, [chore]);
      expect(mockStorage.revision, 1);
    });

    test('get data after losing connection', () async {
      //arrange
      connection = false;
      final chore = Chore(name: 'mocker');

      //act
      dataSource.add(chore);
      connection = true;
      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert
      verify(() => mockStorage.syncronize([chore])).called(1);
      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.revision);
    });
    test('get valid data after losing connection with exactly 1 syncronization',
        () async {
      //arrange
      connection = true;
      final chore = Chore(name: 'mocker');

      //act
      dataSource.add(chore);
      connection = false;
      for (int i = 0; i < 5; i++) {
        dataSource.add(chore.copyWith(name: 'mocker $i'));
      }
      dataSource.remove(dataSource.data!.first, dataSource.data!.first.id);
      dataSource.data?.forEach(
        (e) => dataSource.update(e.copyWith(name: '${e.name} updated'), e.id),
      );
      connection = true;
      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert
      verify(() => mockStorage.syncronize(dataSource.data!)).called(1);
      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.revision);
      expect(loadedData!.length, 5);
    });
  });
}

class MockNetworkStorageProxy<T> extends Mock
    implements NetworkStorageProxy<T> {
  List<T> list = [];
  @override
  int revision = 0;
}
