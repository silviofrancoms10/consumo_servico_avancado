import 'dart:convert';

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
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }
    return postagens;
  }

  _post() async {
    Post post = Post(120, 0, "Title", "Corpo da postagem");

    http.Response response = await http.post(
      Uri.parse(_urlBase + "/posts"),
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: json.encode(post.toJson()),
    );
    print("Resposta Status Code: " + response.statusCode.toString());
    print("Resposta: " + response.body);
  }

  _put() async {
    http.Response response = await http.put(
      Uri.parse("$_urlBase/posts/2"),
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: json.encode({
        "userId": 120,
        "id": null,
        "title": "Teste alterado",
        "body": "Teste alterado"
      }),
    );
    print("Resposta Status Code: " + response.statusCode.toString());
    print("Resposta: " + response.body);
  }

  _patch() async {
    http.Response response = await http.patch(
      Uri.parse("$_urlBase/posts/2"),
      headers: {"Content-type": "application/json; charset=UTF-8"},
      body: json.encode({"userId": 120, "body": "Teste alterado patch"}),
    );
    print("Resposta Status Code: " + response.statusCode.toString());
    print("Resposta: " + response.body);
  }

  _delete() async {
    http.Response response =
    await http.delete(Uri.parse(_urlBase + "/posts/2"));
    print("Resposta Status Code: " + response.statusCode.toString());
    print("Resposta: " + response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviço avançado"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _post,
                  child: Text("Salvar"),
                ),
                ElevatedButton(
                  onPressed: _put,
                  child: Text("Att"),
                ),
                ElevatedButton(
                  onPressed: _patch,
                  child: Text("Att patch"),
                ),
                ElevatedButton(
                  onPressed: _delete,
                  child: Text("Rem"),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Post>>(
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
            ),
          ],
        ),
      ),
    );
  }
}
