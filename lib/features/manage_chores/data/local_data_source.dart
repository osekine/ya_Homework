part of 'i_data_source.dart';

class LocalDataSource<T> implements IDataSource<T> {
  LocalDataSource() {
    _proxy = GetIt.I<LocalStorageProxy<T>>();
  }
  late final LocalStorageProxy<T> _proxy;

  @override
  List<T>? data;

  @override
  int revision = 0;

  @override
  void add(T item) {
    data?.add(item);
    sync();
  }

  @override
  Future<List<T>?> getData() async {
    final loadedData = await _proxy.load();
    revision = loadedData.$1 ?? 0;
    Logs.log('Local rev: $revision');
    data = loadedData.$2;
    return loadedData.$2;
  }

  @override
  void remove(T item, String id) {
    data?.remove(item);
    sync();
  }

  @override
  Future<void> sync() async {
    Logs.log('LOCAL Syncing...');
    revision = revision + 1;
    _proxy.save(data ?? [], revision);
  }

  @override
  void update(T item, String id) {
    sync();
  }
}

abstract class LocalStorageProxy<T> {
  void save(List<T> list, int revision);
  Future<(int?, List<T>?)> load();
}

class SharedPreferncesProxy<T> implements LocalStorageProxy<T> {
  final Future<SharedPreferences> _storage = SharedPreferences.getInstance();

  @override
  void save(List<T> list, int revision) async {
    Logs.log('LOCAL Saving...');
    final storage = await _storage;
    await storage.setStringList(
      'list',
      list.map((e) => jsonEncode(e)).toList(),
    );
    await storage.setInt('revision', revision);
  }

  @override
  Future<(int?, List<T>?)> load() async {
    Logs.log('LOCAL Loading...');
    final storage = await _storage;
    final revision = storage.getInt('revision');
    final list = storage
        .getStringList('list')
        ?.map((e) => Chore.fromJson(jsonDecode(e)) as T) // TODO: fix
        .toList();

    return (revision ?? 0, list ?? []);
  }
}
