import 'package:fast_location/src/modules/home/page/cep_history_page.dart';
import 'package:fast_location/src/modules/home/page/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Location',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Fast Location'),
      routes: {
        '/history': (context) => const CepHistoryPage(),
      },
    );
  }
}
