import 'package:dio/dio.dart';

class DioConfig {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://viacep.com.br/ws/',
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
    ),
  );

  static Future<Map<String, dynamic>> getCep(String cep) async {
    try {
      print("Buscando CEP: $cep"); // Adicionando log
      final response = await _dio.get('$cep/json/');
      print("Resposta da API: ${response.data}"); // Log da resposta

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("Erro ao buscar o CEP, StatusCode: ${response.statusCode}");
        throw Exception('Erro ao buscar CEP');
      }
    } catch (e) {
      print("Erro na requisição: $e"); // Log de erro
      throw Exception('Erro de conexão');
    }
  }
}
