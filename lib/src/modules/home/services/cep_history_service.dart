import 'package:hive/hive.dart';
import 'package:fast_location/src/models/cep_history.dart';

// Método para salvar o histórico de CEP
Future<void> saveCepToHistory(CepHistory cepHistory) async {
  var box = await Hive.openBox<CepHistory>('cepHistory');
  await box.add(cepHistory);
}

// Método para recuperar o histórico de CEPs
Future<List<CepHistory>> getCepHistory() async {
  var box = await Hive.openBox<CepHistory>('cepHistory');
  return box.values.toList();
}
