import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

class LocationPage extends StatelessWidget {
  final Map<String, dynamic> locationData;

  LocationPage({required this.locationData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fast Location"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dados da Localização",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildLocationInfo("Logradouro/Rua:", locationData['logradouro']),
            _buildLocationInfo("Bairro/Distrito:", locationData['bairro']),
            _buildLocationInfo("Cidade/UF:", "${locationData['localidade']}/${locationData['uf']}"),
            _buildLocationInfo("CEP:", locationData['cep']),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _launchMap(locationData);
              },
              child: Text('Localizar endereço'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Define a cor de fundo do botão
                foregroundColor: Colors.white,  // Define a cor do texto do botão
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Voltar para Início'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Define a cor de fundo do botão
                foregroundColor: Colors.white,  // Define a cor do texto do botão
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função que exibe as informações de localização
  Widget _buildLocationInfo(String label, String? value) {
    return value != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              Text(value, style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
            ],
          )
        : SizedBox.shrink();
  }

  // Função que redireciona para o Google Maps
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
