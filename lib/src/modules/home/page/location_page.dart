import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

class LocationPage extends StatelessWidget {
  final Map<String, dynamic> locationData;

  const LocationPage({super.key, required this.locationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fast Location"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dados da Localização",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildLocationInfo("Logradouro/Rua:", locationData['logradouro']),
            _buildLocationInfo("Bairro/Distrito:", locationData['bairro']),
            _buildLocationInfo("Cidade/UF:", "${locationData['localidade']}/${locationData['uf']}"),
            _buildLocationInfo("CEP:", locationData['cep']),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _launchMap(locationData);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // define a cor de fundo do botão
                foregroundColor: Colors.white,  // define a cor do texto do botão
              ),
              child: const Text('Localizar endereço'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // define a cor de fundo do botão
                foregroundColor: Colors.white,  // define a cor do texto do botão
              ),
              child: const Text('Voltar para Início'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(String label, String? value) {
    return value != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              Text(value, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
            ],
          )
        : const SizedBox.shrink();
  }

  void _launchMap(Map<String, dynamic> locationData) async {
    final availableMaps = await MapLauncher.installedMaps;

    if (availableMaps.isNotEmpty) {
      availableMaps.first.showMarker(
        coords: Coords(
          double.parse(locationData['latitude']), 
          double.parse(locationData['longitude'])
        ),
        title: locationData['logradouro'] ?? 'Endereço',
      );
    }
  }
}
