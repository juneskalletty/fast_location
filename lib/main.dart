import 'package:fast_location/src/modules/home/page/cep_history_page.dart';
import 'package:fast_location/src/modules/home/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fast_location/src/models/cep_history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CepHistoryAdapter());
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Location',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomePage(title: ''),
      routes: {
        '/history': (context) => const CepHistoryPage(),
      },
    );
  }
}