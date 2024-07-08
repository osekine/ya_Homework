import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/core/models/chore.dart';
import 'package:to_do_app/core/utils/logs.dart';

part 'local_data_source.dart';
part 'network_data_source.dart';

abstract class IDataSource<T> {
  List<T>? data;
  int revision = 0;

  void add(T item);
  void remove(T item, String id);
  Future<List<T>?> getData();
  Future<void> sync();
  void update(T item, String id);
}
