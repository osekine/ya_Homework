import 'package:to_do_app/core/models/chore.dart';

import '../../../core/utils/logs.dart';
import 'i_data_source.dart';

class ClientModel<T extends Chore> implements IDataSource<T> {
  IDataSource<T>? _localStorage;
  IDataSource<T>? _networkStorage;

  @override
  List<T>? data;

  @override
  int revision = 0;

  ClientModel({this.data}) {
    _localStorage = LocalDataSource<T>();
    _networkStorage = NetworkDataSource<T>();
  }

  @override
  void add(T item) {
    revision = revision + 1;
    Logs.log('Client rev: $revision');
    _localStorage?.add(item);
    _networkStorage?.add(item);
  }

  @override
  Future<List<T>?> getData() async {
    List<T>? networkData;
    List<T>? localData;
    try {
      networkData = await _networkStorage?.getData();
    } catch (e) {
      Logs.log('$e');
    }
    try {
      localData = await _localStorage?.getData();
    } catch (e) {
      Logs.log('$e');
    }

    //Проверка на совпадение версии. Если network отстает - синхронизируем с local и наоборот
    if (networkData != null) {
      if (_localStorage?.revision != null) {
        if (_localStorage!.revision > _networkStorage!.revision) {
          _networkStorage!.data = List.from(localData as Iterable);
          await _networkStorage!.sync();
        } else {
          _localStorage!.data = List.from(networkData as Iterable);
          await _localStorage!.sync();
        }
        _localStorage!.revision = _networkStorage!.revision;
      }
      data = _networkStorage!.data;
      revision = _networkStorage!.revision;
    } else {
      data = _localStorage?.data ?? [];
      revision = _localStorage?.revision ?? 0;
    }

    _networkStorage?.revision = revision;
    _localStorage?.revision = revision;

    return data;
  }

  @override
  void remove(T item, String id) async {
    _localStorage?.remove(item, id);
    _networkStorage?.remove(item, id);
  }

  @override
  Future<void> sync() async {
    await getData();
  }

  @override
  void update(T item, String id) {
    data?[data!.indexOf(item)] = item;
    _localStorage?.update(item, id);
    _networkStorage?.update(item, id);
  }

  @override
  Future<T?> getItem(String? id) async {
    return _networkStorage?.getItem(id) ?? _localStorage?.getItem(id);
  }
}
