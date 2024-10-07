import 'package:hive/hive.dart';

part 'cep_history.g.dart';

@HiveType(typeId: 0)
class CepHistory extends HiveObject {
  @HiveField(0)
  final String cep;

  @HiveField(1)
  final String logradouro;

  @HiveField(2)
  final String bairro;

  @HiveField(3)
  final String localidade;

  @HiveField(4)
  final String uf;

  @HiveField(5)
  final DateTime dateTime;

  CepHistory({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
    required this.dateTime,
  });
}
