import 'package:dio/dio.dart';

class DioConfig {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://viacep.com.br/ws/',
      connectTimeout: const Duration(milliseconds: 5000), // Corrigido para usar Duration
      receiveTimeout: const Duration(milliseconds: 3000), // Corrigido para usar Duration
    ),
  );

  static Future<Map<String, dynamic>> getCep(String cep) async {
    try {
      final response = await _dio.get('$cep/json/');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Erro ao buscar CEP');
      }
    } catch (e) {
      throw Exception('Erro de conexão');
    }
  }
}
