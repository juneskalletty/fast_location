import 'package:dio/dio.dart';

class DioConfig {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://viacep.com.br/ws/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  static Future<Map<String, dynamic>> getCep(String cep) async {
    try {
      final response = await _dio.get('$cep/json/');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Erro ao buscar o CEP');
      }
    } catch (e) {
      throw Exception('Erro de conexão');
    }
  }
}
