import 'package:hive_flutter/hive_flutter.dart';

class AppStorage {
  static Future<void> init() async {
    await Hive.initFlutter();
    // Registrar adaptadores Hive aqui
  }
}
