import 'package:hive/hive.dart';
import 'package:fast_location/src/models/cep_history.dart';

Future<void> saveCepToHistory(CepHistory cepHistory) async {
  var box = await Hive.openBox<CepHistory>('cepHistory');
  await box.add(cepHistory);
}

Future<List<CepHistory>> getCepHistory() async {
  var box = await Hive.openBox<CepHistory>('cepHistory');
  return box.values.toList();
}
