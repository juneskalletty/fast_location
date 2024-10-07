import 'package:fast_location/src/http/dio_config.dart';
import 'package:fast_location/src/modules/home/services/cep_history_service.dart';
import 'package:flutter/material.dart';
import 'package:fast_location/src/models/cep_history.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _openInMaps(String address) async {
    try {
      if (address.isEmpty) {
        throw 'Endereço está vazio.';
      }

      print('Endereço para geocodificação: $address');

      // Usando Nominatim API do OpenStreetMap
      String apiUrl =
          'https://nominatim.openstreetmap.org/search?q=$address&format=json';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Dados recebidos da geocodificação: $data');
        if (data.isEmpty) {
          throw 'Nenhuma localização encontrada para o endereço fornecido.';
        }

        var location = data[0];
        double latitude = double.parse(location['lat']);
        double longitude = double.parse(location['lon']);
        print('Latitude: $latitude, Longitude: $longitude');

        // Abrir Google Maps diretamente com URL
        String googleMapsUrl =
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
        if (await canLaunch(googleMapsUrl)) {
          await launch(googleMapsUrl);
        } else {
          throw 'Não foi possível abrir o Google Maps.';
        }
      } else {
        throw 'Erro na solicitação: ${response.statusCode}';
      }
    } catch (e) {
      print('Erro ao abrir o mapa: $e');
    }
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
                  await _openInMaps(
                      '${address['logradouro']}, ${address['localidade']}, ${address['uf']}, Brasil');
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
            content: const Text(
                'Falha ao buscar o CEP. Verifique e tente novamente.'),
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
}
