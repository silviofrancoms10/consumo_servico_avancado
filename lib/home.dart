import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> _recuperarPreco() async {
    String url = "https://blockchain.info/ticker";
    http.Response response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      builder: (context, snapshot) {
        String _resultado;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            _resultado = "Conexao none";
            break;
          case ConnectionState.waiting:
            print("Conexao waiting");
            _resultado = "Carregando...";
            break;
          case ConnectionState.active:
            _resultado = "Conexao active";
            break;
          case ConnectionState.done:
            print("Conexão done");
            if (snapshot.hasError){
              _resultado = "Erro ao carregar os dados";
            }else{
              double valor = snapshot.data!["BRL"]["buy"];
              _resultado = "Preço do Bitcoin: R\$ $valor";
            }
              break;
        }
        return Center(
          child: Text(_resultado),
        );
      },
    );
  }
}
