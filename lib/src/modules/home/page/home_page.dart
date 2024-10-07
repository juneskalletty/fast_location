import 'package:fast_location/src/http/dio_config.dart';
import 'package:fast_location/src/modules/home/services/cep_history_service.dart';
import 'package:flutter/material.dart';
import 'package:fast_location/src/models/cep_history.dart';
import 'package:map_launcher/map_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  final String title;

  const HomePage({super.key, required this.title});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
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
              child: const Text('Localizar endereço'),
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
              child: const Text('Histórico de endereços'),
            ),
          ],
        ),
      ),
    );
  }

  // Mostra o input para o usuário digitar o CEP
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
                final scaffoldContext = _scaffoldKey.currentContext!;
                await _searchCep(scaffoldContext, cep);
              },
              child: const Text('Buscar'),
            ),
          ],
        );
      },
    );
  }

  // Método que busca o CEP e exibe o resultado
  Future<void> _searchCep(BuildContext context, String cep) async {
    try {
      final response = await DioConfig.getCep(cep);

      // Casting explícito para Map<String, dynamic>
      Map<String, dynamic> address = Map<String, dynamic>.from(response);

      // Criar e salvar o histórico de CEP
      CepHistory cepHistory = CepHistory(
        cep: cep,
        logradouro: address['logradouro'],
        bairro: address['bairro'],
        localidade: address['localidade'],
        uf: address['uf'],
        dateTime: DateTime.now(),
      );
      await saveCepToHistory(cepHistory);

      // Exibir resultado e perguntar se quer abrir no mapa
      if (!mounted) return;
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
                  await _openInMaps(address['logradouro'], address['localidade']);
                },
                child: const Text('Abrir no Mapa'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Erro na busca do CEP: $cep");
      if (!mounted) return;
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

Future<void> _openInMaps(String logradouro, String localidade) async {
  try {
    if (logradouro.isEmpty || localidade.isEmpty) {
      throw 'Logradouro ou localidade estão vazios.';
    }

    String address = '$logradouro, $localidade, São Paulo, Brasil';
    print('Endereço para geocodificação: $address');

    // Usando Nominatim API do OpenStreetMap
    String apiUrl = 'https://nominatim.openstreetmap.org/search?q=$address&format=json';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('Dados recebidos da geocodificação: $data');
      if (data.isEmpty) {
        throw 'Nenhuma localização encontrada para o endereço fornecido.';
      }

      var location = data[0];
      if (location['lat'] == null || location['lon'] == null) {
        throw 'Coordenadas nulas recebidas para o endereço fornecido.';
      }

      double latitude = double.parse(location['lat']);
      double longitude = double.parse(location['lon']);
      print('Latitude: $latitude, Longitude: $longitude');

      // Verifica se o Google Maps está disponível
      bool googleMapsAvailable = false;
      try {
        googleMapsAvailable = await MapLauncher.isMapAvailable(MapType.google) ?? false;
      } catch (e) {
        print('Erro ao verificar a disponibilidade do Google Maps: $e');
      }

      print('Google Maps disponível: $googleMapsAvailable');

      if (googleMapsAvailable) {
        await MapLauncher.showMarker(
          mapType: MapType.google,
          coords: Coords(latitude, longitude),
          title: address,
          description: "Endereço buscado",
        );
      } else {
        print('Google Maps não está disponível.');
      }
    } else {
      throw 'Erro na solicitação: ${response.statusCode}';
    }
  } catch (e) {
    print('Erro ao abrir o mapa: $e');
  }
}

}
