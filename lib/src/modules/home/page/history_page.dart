import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lista fictícia de históricos. No seu projeto, essa lista deve ser carregada do Hive.
    final List<Map<String, String>> history = [
      {"logradouro": "Rodovia José Carlos Daux", "cidade": "Florianópolis", "cep": "88032-005"},
      // Adicione outros endereços aqui
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de Endereços"),
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
