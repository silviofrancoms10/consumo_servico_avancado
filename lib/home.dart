import 'dart:convert';
import 'dart:ffi';

import 'package:consumo_servico_avancado/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _urlBase = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get(Uri.parse(_urlBase + "/posts"));
    var dadosJson = jsonDecode(response.body);

    List<Post> postagens = List.empty(growable: true);
    for (var post in dadosJson) {
      print("post: " + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }
    return postagens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: FutureBuilder<List<Post>>(
        future: _recuperarPostagens(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              print("Conexão done");
              if (snapshot.hasError) {
                print("Lista: Erro ao carregar");
              } else {
                print("Lista carregada com sucesso");
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {

                    List<Post> lista = snapshot.data!;
                    Post post = lista[index];

                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.id.toString()),
                    );
                  },
                );
              }
              break;
          }
          return Center(
              //child: Text(_resultado),
              );
        },
      ),
    );
  }
}
