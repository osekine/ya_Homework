import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/models/chore.dart';
import 'package:to_do_app/utils/logs.dart';

part 'local_data_source.dart';
part 'network_data_source.dart';

abstract class IDataSource<T> {
  List<T>? data;
  int revision = 0;

  void add(T item);
  void remove(T item, String id);
  Future<List<T>?> getData();
  void sync();
  void update(T item, String id);
}
