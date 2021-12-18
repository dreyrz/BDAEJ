import 'package:dio/dio.dart';

class Api {
  static const url = "https://trabalhodb-ufs2021.000webhostapp.com/db/";
  final method = Dio(BaseOptions(
    baseUrl: url,
  ));
}
