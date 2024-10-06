# Fast Location

Fast Location é um aplicativo Flutter para consulta de CEPs e endereços, com a funcionalidade de exibir o histórico de buscas realizadas. Além disso, o aplicativo permite a navegação até o endereço pesquisado através do Google Maps.

## Funcionalidades

- Consulta de endereços a partir de um CEP informado.
- Exibição detalhada do endereço encontrado.
- Armazenamento de consultas de CEP no histórico local.
- Redirecionamento para o Google Maps com o endereço encontrado.
- Interface amigável e intuitiva.

## Tecnologias Utilizadas

- **Flutter**: Framework principal do aplicativo.
- **Dio**: Biblioteca para requisições HTTP.
- **MobX**: Gerenciamento de estado reativo.
- **Hive**: Armazenamento de dados local.
- **Google Maps**: Integração para navegação até o endereço.
- **Geocoding**: Conversão de coordenadas geográficas em endereços.

## Instalação

1. **Clone o repositório**:

    ```bash
    git clone https://github.com/juneskalletty/fast_location.git
    ```

2. **Instale as dependências**:

    ```bash
    flutter pub get
    ```

3. **Execute o aplicativo**:

    ```bash
    flutter run
    ```

## Estrutura do Projeto

- `lib/`: Contém o código fonte do aplicativo.
  - `src/models/`: Modelos usados no app, como `CepHistory`.
  - `src/http/`: Contém a configuração de rede, como `DioConfig`.
  - `src/modules/home/`: Código relacionado à página inicial do aplicativo.
  - `src/modules/history/`: Código relacionado ao histórico de buscas.
  
- `android/`: Configurações e arquivos do Android.
- `ios/`: Configurações e arquivos do iOS.

## Uso

1. **Consulta de CEP**:
    - Na tela principal, pressione o botão "Localizar endereço".
    - Insira um CEP válido e pressione "Buscar".
    - O endereço correspondente será exibido na tela.

2. **Histórico de Endereços**:
    - Para visualizar as consultas anteriores, pressione o botão "Histórico de endereços" na tela principal.

3. **Navegação no Google Maps**:
    - Após consultar um endereço, pressione o botão "Abrir no Google Maps" para ser redirecionado ao aplicativo de mapas.

## Dependências

Aqui estão as principais dependências utilizadas no projeto:

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.7.0
  flutter_mobx: ^2.0.4
  mobx: ^2.3.3+2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path: ^1.9.0
  path_provider: ^2.1.4
  map_launcher: ^3.5.0
  geocoding: ^3.0.0
