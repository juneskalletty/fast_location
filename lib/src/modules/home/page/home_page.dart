import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fast Location"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 50, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Faça uma busca para localizar seu destino',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Chamar função que abrirá o pop-up de inserção de CEP
                _showCepInputDialog(context);
              },
              child: Text('Localizar endereço'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Definir cor de fundo
                foregroundColor: Colors.white,  // Definir cor do texto
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar para a tela de histórico
                Navigator.pushNamed(context, '/history');
              },
              child: Text('Histórico de endereços'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Definir cor de fundo
                foregroundColor: Colors.white,  // Definir cor do texto
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para exibir o pop-up de inserção de CEP
  void _showCepInputDialog(BuildContext context) {
    String cep = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Digite o CEP'),
          content: TextField(
            onChanged: (value) {
              cep = value;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'CEP'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Função para buscar o CEP (a implementar)
                _searchCep(cep);
              },
              child: Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  // Função que buscará o endereço com base no CEP inserido
  void _searchCep(String cep) {
    // Implementar busca do CEP com DioConfig.getCep
  }
}
