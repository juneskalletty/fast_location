import 'package:fast_location/src/http/dio_config.dart';
import 'package:fast_location/src/modules/home/services/cep_history_service.dart';
import 'package:flutter/material.dart';
import 'package:fast_location/src/models/cep_history.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:geocoding/geocoding.dart'; // Importação para obter coordenadas

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
            // Bloco com o texto "Faça uma busca para localizar seu destino"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Faça uma busca para localizar seu destino',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
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
            // Alinhamento central do título "Últimos endereços localizados"
            const Text(
              'Últimos endereços localizados',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
              textAlign: TextAlign.center, // Alinhando o texto ao centro
            ),
            const SizedBox(height: 10),
            // Bloco para exibição de locais recentes ou a mensagem "Não há locais recentes"
            FutureBuilder<String?>(
              future: getLastSearchedAddress(), // função que retorna o último endereço consultado
              builder: (context, snapshot) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: snapshot.hasData && snapshot.data!.isNotEmpty
                      ? Text(
                          snapshot.data!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        )
                      : const Text(
                          'Não há locais recentes',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                );
              },
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

  // Função que busca o último endereço consultado
  Future<String?> getLastSearchedAddress() async {
    final history = await getCepHistory();
    if (history.isNotEmpty) {
      final lastAddress = history.last;
      return "${lastAddress.logradouro}, ${lastAddress.localidade}";
    }
    return null;
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
                await _searchCep(context, cep);
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
      print("Iniciando a busca do CEP: $cep");
      final response = await DioConfig.getCep(cep);
      print("Endereço retornado: $response");

      Map<String, dynamic> address = response;

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
      print("Erro na busca do CEP: $e");
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

  // Função para abrir o endereço no Google Maps
  Future<void> _openInMaps(String logradouro, String localidade) async {
    try {
      List<Location> locations = await locationFromAddress('$logradouro, $localidade');
      if (locations.isNotEmpty) {
        Location location = locations.first;
        if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
          await MapLauncher.showMarker(
            mapType: MapType.google,
            coords: Coords(location.latitude, location.longitude),
            title: "$logradouro, $localidade",
            description: "Endereço buscado",
          );
        } else {
          print('Google Maps não está disponível.');
        }
      }
    } catch (e) {
      print('Erro ao abrir o mapa: $e');
    }
  }
}