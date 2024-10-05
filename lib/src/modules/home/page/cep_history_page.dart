import 'package:fast_location/src/modules/home/services/cep_history_service.dart';
import 'package:flutter/material.dart';
import 'package:fast_location/src/models/cep_history.dart';

class CepHistoryPage extends StatelessWidget {
  const CepHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Endereços'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<CepHistory>>(
        future: getCepHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar histórico.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum histórico disponível.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final cepHistory = snapshot.data![index];
                return ListTile(
                  title: Text(cepHistory.cep),
                  subtitle: Text(
                      '${cepHistory.logradouro}, ${cepHistory.bairro}, ${cepHistory.localidade}, ${cepHistory.uf}'),
                  trailing: Text(
                      '${cepHistory.dateTime.day}/${cepHistory.dateTime.month}/${cepHistory.dateTime.year}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
