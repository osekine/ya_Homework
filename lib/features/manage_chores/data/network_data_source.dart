part of 'i_data_source.dart';

class NetworkDataSource<T> implements IDataSource<T> {
  final DioProxy<T> _proxy = DioProxy();

  @override
  List<T>? data;

  @override
  int revision = 0;

  @override
  void add(T item) {
    data?.add(item);
    _proxy.save(item);
    revision = _proxy.revision;
  }

  @override
  Future<List<T>?> getData() async {
    data = await _proxy.load();
    revision = _proxy.revision;
    return data ?? [];
  }

  @override
  void remove(T item, String id) {
    data?.remove(item);
    _proxy.delete(id);
  }

  @override
  void sync() {
    _proxy.syncronize(data!);
  }

  @override
  void update(T item, String id) {
    _proxy.update(item, id);
  }
}

class DioProxy<T> {
  final String baseUrl = 'https://hive.mrdekk.ru/todo/list';
  final String token = 'Wilwarin';
  int revision = 0;

  final _dio = Dio();

  DioProxy() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer $token';
          options.headers['X-Last-Known-Revision'] = revision;
          options.connectTimeout = const Duration(seconds: 1);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.requestOptions.method != 'GET' &&
              response.statusCode == 200) {
            revision++;
          }
          return handler.next(response);
        },
      ),
    );
  }
  Future<List<T>> load() async {
    Logs.log('NETWORK Loading...');
    List<T>? loadedData;
    try {
      final Response<String> response = await _dio.get(baseUrl);
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.data!);
        final listBody = jsonBody['list'] as List;
        revision = jsonBody['revision'] as int;

        //Буду очень рад помощи по этому костылю
        loadedData =
            listBody.map((e) => Chore.fromJson(e) as T).toList(); //TODO: fix
        Logs.log('Network Rev: $revision');
      }
    } catch (e) {
      Logs.elog('$e');
    }
    return Future.value(loadedData ?? []);
  }

  void save(T data) async {
    Logs.log('NETWORK Saving...');
    final body = jsonEncode(
      data,
      toEncodable: ((nonEncodable) =>
          data is Chore ? data.toJson() : nonEncodable),
    );
    try {
      Logs.log('Saving: $body');

      final Response<String> response = await _dio.post(
        baseUrl,
        data: <String, dynamic>{'element': jsonDecode(body)},
      );
      Logs.log(response.data!);
    } catch (e) {
      Logs.elog('$e');
    }
  }

  void update(T data, String id) async {
    Logs.log('NETWORK Updating...');
    final body = jsonEncode(
      data,
      toEncodable: ((nonEncodable) =>
          data is Chore ? data.toJson() : nonEncodable),
    ); //TODO: fix
    try {
      await _dio.put(
        '$baseUrl/$id',
        data: <String, dynamic>{'element': jsonDecode(body)},
      );
    } catch (e) {
      Logs.elog('$e');
    }
  }

  void delete(String id) async {
    Logs.log('NETWORK Deleting...');
    try {
      await _dio.delete('$baseUrl/$id');
    } catch (e) {
      Logs.elog('$e');
    }
  }

  void syncronize(List<T> data) async {
    Logs.log('NETWORK syncronizing...');
    final body = jsonEncode(data);
    Logs.log(body);
    try {
      await _dio.patch(baseUrl, data: {'list': jsonDecode(body)});
    } catch (e) {
      Logs.elog('$e');
    }
  }
}
