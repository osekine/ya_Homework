import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:to_do_app/core/models/chore.dart';
import 'package:to_do_app/features/manage_chores/data/i_data_source.dart';

import 'mock_behavior/mock_network_behavior.dart';

void main() {
  late IDataSource<Chore> dataSource;
  late final MockNetworkStorageProxy<Chore> mockStorage;
  late final MockNetworkBehavior<Chore> mockBehavior;

  setUpAll(() {
    registerFallbackValue(Chore(name: 'mocker'));
    mockStorage = GetIt.I.registerSingleton<NetworkStorageProxy<Chore>>(
      MockNetworkStorageProxy<Chore>(),
    ) as MockNetworkStorageProxy<Chore>;
    mockBehavior = MockNetworkBehavior<Chore>(
      mockStorage: mockStorage,
    );
  });

  setUp(() {
    dataSource = NetworkDataSource<Chore>()..data = [];
    mockStorage
      ..list = []
      ..revision = 0;

    mockBehavior
      ..onLoad()
      ..onSave()
      ..onDelete()
      ..onSync()
      ..onUpdate();
  });

  group('Testing network repository', () {
    test('save data to Network', () async {
      //arrange
      mockBehavior.connection = true;
      final chore = Chore(name: 'mocker');

      //act
      dataSource.add(chore);

      //assert
      expect(mockStorage.list, [chore]);
      expect(mockStorage.revision, 1);
    });

    test('load data from Network', () async {
      //arrange
      mockBehavior.connection = true;

      //act
      final loadedData = await dataSource.getData();
      final rev = dataSource.revision;

      //assert

      expect(loadedData, mockStorage.list);
      expect(rev, mockStorage.revision);
    });

    test('get valid data and revision after saving', () async {
      //arrange
      mockBehavior.connection = true;
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
      mockBehavior.connection = true;
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
      mockBehavior.connection = true;
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
      expect(mockStorage.list?.first.name, expectedChore.name);
    });

    test('syncronize after losing connection', () async {
      //arrange
      mockBehavior.connection = false;
      final chore = Chore(name: 'mocker');

      //act
      dataSource.add(chore);
      mockBehavior.connection = true;
      dataSource.sync();

      //assert
      expect(mockStorage.list, [chore]);
      expect(mockStorage.revision, 1);
    });

    test('get data after losing connection', () async {
      //arrange
      mockBehavior.connection = false;
      final chore = Chore(name: 'mocker');

      //act
      dataSource.add(chore);
      mockBehavior.connection = true;
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
      mockBehavior.connection = true;
      final chore = Chore(name: 'mocker');

      //act
      dataSource.add(chore);
      mockBehavior.connection = false;
      for (int i = 0; i < 5; i++) {
        dataSource.add(chore.copyWith(name: 'mocker $i'));
      }
      dataSource.remove(dataSource.data!.first, dataSource.data!.first.id);
      dataSource.data?.forEach(
        (e) => dataSource.update(e.copyWith(name: '${e.name} updated'), e.id),
      );
      mockBehavior.connection = true;
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
