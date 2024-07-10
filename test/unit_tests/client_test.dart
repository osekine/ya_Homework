import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:to_do_app/core/models/chore.dart';
import 'package:to_do_app/features/manage_chores/data/client.dart';
import 'package:to_do_app/features/manage_chores/data/i_data_source.dart';

import 'mock_behavior/mock_local_behavior.dart';
import 'mock_behavior/mock_network_behavior.dart';

void main() {
  late ClientModel<Chore> client;
  late final MockLocalStorageProxy<Chore> mockLocal;
  late final MockNetworkStorageProxy<Chore> mockNetwork;
  late final MockLocalBehavior<Chore> mockLocalBehavior;
  late final MockNetworkBehavior<Chore> mockNetworkBehavior;

  setUpAll(() {
    registerFallbackValue(Chore(name: 'mocker'));
    mockLocal = GetIt.I.registerSingleton<LocalStorageProxy<Chore>>(
      MockLocalStorageProxy<Chore>(),
    ) as MockLocalStorageProxy<Chore>;

    mockNetwork = GetIt.I.registerSingleton<NetworkStorageProxy<Chore>>(
      MockNetworkStorageProxy<Chore>(),
    ) as MockNetworkStorageProxy<Chore>;

    mockLocalBehavior = MockLocalBehavior<Chore>(
      mockStorage: mockLocal,
    );

    mockNetworkBehavior = MockNetworkBehavior<Chore>(
      mockStorage: mockNetwork,
    );
  });

  setUp(() {
    client = ClientModel<Chore>();

    mockLocal
      ..list = []
      ..revision = 0;

    mockNetwork
      ..list = []
      ..revision = 0;

    mockLocalBehavior
      ..onLoad()
      ..onSave();

    mockNetworkBehavior
      ..onLoad()
      ..onSave()
      ..onDelete()
      ..onUpdate()
      ..onSync();
  });

  group('Testing client repository', () {
    test('add Chore with right data', () async {
      //arrange
      mockNetworkBehavior.connection = true;
      final chore = Chore(name: 'mocker');

      //act
      client.add(chore);

      //assert
      expect(mockLocal.list, [chore]);
      expect(mockLocal.revision, 1);
      expect(mockNetwork.list, [chore]);
      expect(mockNetwork.revision, 1);
    });

    test('get data', () async {
      //arrange
      final chore = Chore(name: 'mocker');
      mockNetworkBehavior.connection = true;
      client.add(chore);

      //act
      final data = await client.getData();

      //assert
      expect(data, [chore]);
      expect(client.revision, 1);
      expect(mockLocal.list, [chore]);
      expect(mockNetwork.list, [chore]);
    });

    test('remove Chore', () async {
      //arrange
      final chore = Chore(name: 'mocker');
      mockNetworkBehavior.connection = true;
      client
        ..add(chore)
        ..remove(chore, chore.id);

      //assert
      expect(mockLocal.list, []);
      expect(mockLocal.revision, 2);
      expect(mockNetwork.list, []);
      expect(mockNetwork.revision, 2);
    });

    test('update Chore', () async {
      //arrange
      final chore = Chore(name: 'mocker');
      mockNetworkBehavior.connection = true;
      client.add(chore);

      //act
      // final newChore = chore.copyWith(name: 'mocker2');
      chore.name = 'mocker2';
      client.update(chore, chore.id);

      //assert
      expect(mockLocal.list.first.name, chore.name);
      expect(mockLocal.revision, 2);
      expect(mockNetwork.list?.first.name, chore.name);
      expect(mockNetwork.revision, 2);
    });

    test('saving without connection', () async {
      //arrange
      final chore = Chore(name: 'mocker');
      mockNetworkBehavior.connection = false;
      client.add(chore);

      //act
      await client.sync();

      //assert
      expect(mockLocal.list, [chore]);
      expect(client.data, [chore]);
      expect(mockLocal.revision, 1);
      expect(mockNetwork.list, []);
    });

    test('load after restore connection', () async {
      //arrange
      final chore = Chore(name: 'mocker');
      mockNetworkBehavior.connection = true;
      client.add(chore);

      expect(mockNetwork.list!, [chore]);

      //act
      mockNetworkBehavior.connection = false;
      for (int i = 0; i < 10; i++) {
        final newChore = Chore(name: i.toString());
        client.add(newChore);
      }
      mockNetworkBehavior.connection = true;
      // client.add(Chore(name: '-1'));

      await client.sync();

      //assert
      expect(mockLocal.list.length, 11);
      expect(mockNetwork.list?.length, 11);
      // expect(mockNetwork.list?.last.name, '-1');
      expect(mockLocal.revision, 11);
      expect(mockNetwork.revision, 2);
    });
  });
}
