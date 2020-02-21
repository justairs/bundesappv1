import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Time> fetchTime() async {
  final response = await http.get('https://www.parsehub.com/api/v2/runs/tkL_dZT-n8jT/data?api_key=tau1-4-7WTCX');
  final responseJson = json.decode(response.body);

  return Time.fromJson(responseJson);
}

class Time{
  final String Nome;
  /*final String Nome;
  final int pontos;
  final int vitorias;
  final int empates;
  final int derrotas;
  final int gols_marcados;
  final int gols_sofridos;
  final int aproveitamento;
*/
  Time({this.Nome});

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      Nome: json['classificacao[Barcelona]']
    );
  }

}
/*class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
*/
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Time> futureTime;

  @override
  void initState() {
    super.initState();
    futureTime = fetchTime();
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
          child: FutureBuilder<Time>(
            future: futureTime,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.Nome);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
