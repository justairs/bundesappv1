import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Classificacao> fetchClassificacao() async {
  final response = await http.get(
      'https://www.parsehub.com/api/v2/runs/tLTJeXqG80HC/data?api_key=tau1-4-7WTCX');
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    return Classificacao.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Deu ruim');
  }
}

class Classificacao {
  List<Clube> clube;

  Classificacao({this.clube});

  Classificacao.fromJson(Map<String, dynamic> json) {
    if (json['Clube'] != null) {
      clube = new List<Clube>();
      json['Clube'].forEach((v) {
        clube.add(new Clube.fromJson(v));
      });
    }
  }
}

class Clube {
  String posicao;
  String logoUrl;
  String time;
  String pontos;
  String vitorias;
  String empates;
  String derrotas;
  String golsmarcados;
  String golsofridos;
  String aproveitamento;

  Clube({this.posicao,
    this.logoUrl,
    this.time,
    this.pontos,
    this.vitorias,
    this.empates,
    this.derrotas,
    this.golsmarcados,
    this.golsofridos,
    this.aproveitamento});

  Clube.fromJson(Map<String, dynamic> json) {
    posicao = json['posicao'];
    logoUrl = json['logo_url'];
    time = json['time'];
    pontos = json['pontos'];
    vitorias = json['vitorias'];
    empates = json['empates'];
    derrotas = json['derrotas'];
    golsmarcados = json['golsmarcados'];
    golsofridos = json['golsofridos'];
    aproveitamento = json['aproveitamento'];
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Classificacao> futureClassificacao;

  @override
  void initState() {
    super.initState();
    futureClassificacao = fetchClassificacao();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tentativa de request',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tentativa de request'),
        ),
        body: Center(
          child: FutureBuilder<Classificacao>(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.clube.first.time);
                //Mostrando dados do primeiro colocado
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
            future: futureClassificacao,
          ),
        ),
      ),
    );
  }
}
