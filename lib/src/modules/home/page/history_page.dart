import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // lista ficticia. 
    final List<Map<String, String>> history = [
      {"logradouro": "Rodovia José Carlos Daux", "cidade": "Florianópolis", "cep": "88032-005"},

    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Endereços"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final address = history[index];
          return ListTile(
            title: Text(address["logradouro"] ?? ""),
            subtitle: Text("${address["cidade"]}, ${address["cep"]}"),
          );
        },
      ),
    );
  }
}
