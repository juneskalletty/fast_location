import 'package:fast_location/src/http/dio_config.dart';
import 'package:fast_location/src/modules/home/services/cep_history_service.dart';
import 'package:flutter/material.dart';
import 'package:fast_location/src/models/cep_history.dart';
import 'package:map_launcher/map_launcher.dart'; // Import map_launcher

class HomePage extends StatelessWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 50, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Faça uma busca para localizar seu destino',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showCepInputDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Localizar endereço'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text('Histórico de endereços'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCepInputDialog(BuildContext context) {
    String cep = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Digite o CEP'),
          content: TextField(
            onChanged: (value) {
              cep = value;
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'CEP'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _searchCep(context, cep);
              },
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _searchCep(BuildContext context, String cep) async {
    try {
      final response = await DioConfig.getCep(cep);

      // casting explicito para Map<String, dynamic>
      Map<String, dynamic> address = response as Map<String, dynamic>;

      // criar e salvar o historico de CEP
      CepHistory cepHistory = CepHistory(
        cep: cep,
        logradouro: address['logradouro'],
        bairro: address['bairro'],
        localidade: address['localidade'],
        uf: address['uf'],
        dateTime: DateTime.now(),
      );

      await saveCepToHistory(cepHistory);

      // exibir resultado e perguntar se quer abrir no mapa
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Endereço encontrado'),
            content: Text(
              'Endereço: ${address['logradouro']}, ${address['bairro']}, ${address['localidade']}, ${address['uf']}',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Abrir o endereço no Google Maps
                  await _openInMaps(address['localidade'], address['uf']);
                },
                child: const Text('Abrir no Mapa'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Falha ao buscar o CEP. Verifique e tente novamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _openInMaps(String localidade, String uf) async {
    try {
      // verifica se o google maps esta disponivel
      if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
        await MapLauncher.showMarker(
          mapType: MapType.google,
          coords: Coords(0, 0), // aqui pode passar as coordenadas
          title: "$localidade, $uf",
          description: "Endereço buscado",
        );
      } else {
        print('Google Maps não está disponível.');
      }
    } catch (e) {
      print('Erro ao abrir o mapa: $e');
    }
  }
}
