import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  // URLs pour Ganache
  final String _rpcUrl = "http://127.0.0.1:7545";      // RPC HTTP de Ganache
final String _wsUrl = "ws://127.0.0.1:7545/";       // WebSocket (facultatif pour Web3dart)

  final String _privateKey = "0x5013541bb68497b4315f25787c10ed498d81d609d28fa4395561db831fa8fba9"; // Remplace par ta clé privée

  // Variables Web3dart
  late Web3Client _client;
  bool isLoading = true;
  late String _abiCode;
  late EthereumAddress _contractAddress;
  late Credentials _credentials;
  late DeployedContract _contract;
  late ContractFunction _yourName;
  late ContractFunction _setName;
  late String deployedName;

  // Constructeur
  ContractLinking() {
    initialSetup();
  }

  // Initialisation du contrat
  Future<void> initialSetup() async {
    // Connexion au client RPC Ethereum via WebSocket
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
  }

  // Lecture de l'ABI et de l'adresse du contrat
  Future<void> getAbi() async {
    String abiStringFile = await rootBundle.loadString("assets/artifacts/HelloWorld.json");
    var jsonAbi = jsonDecode(abiStringFile);
    _abiCode = jsonEncode(jsonAbi["abi"]);
    _contractAddress = EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
  }

  // Obtention des credentials à partir de la clé privée
  Future<void> getCredentials() async {
    _credentials = await _client.credentialsFromPrivateKey(_privateKey);
  }

  // Chargement du contrat déployé
  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
      ContractAbi.fromJson(_abiCode, "HelloWorld"),
      _contractAddress,
    );

    _yourName = _contract.function("yourName");
    _setName = _contract.function("setName");

    await getName();
  }

  // Récupération du nom actuel dans le contrat
  Future<void> getName() async {
    var currentName = await _client.call(
      contract: _contract,
      function: _yourName,
      params: [],
    );
    deployedName = currentName[0];
    isLoading = false;
    notifyListeners();
  }

  // Mise à jour du nom dans le contrat
  Future<void> setName(String nameToSet) async {
    isLoading = true;
    notifyListeners();

    await _client.sendTransaction(
      _credentials,
      Transaction.callContract(
        contract: _contract,
        function: _setName,
        parameters: [nameToSet],
      ),
    );

    await getName();
  }
}
