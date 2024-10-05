import 'package:dio/dio.dart';

class DioConfig {
  static Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://viacep.com.br/ws/',
    ),
  );

  static Future<Response> getCep(String cep) async {
    try {
      Response response = await dio.get('$cep/json/');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
