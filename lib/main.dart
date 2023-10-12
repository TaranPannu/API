import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Ab {
  final int userId;
  final int id;
  final String title;

  Ab({required this.userId, required this.id, required this.title});

  factory Ab.fromJson(Map<String, dynamic> json) {
    return Ab(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Ab>? futureAlbum;

  void fetchAlbumData() {
    setState(() {
      futureAlbum = fetchAlbum();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  fetchAlbumData();
                },
                child: Text("press"),
              ),
              if (futureAlbum != null)
                FutureBuilder<Ab>(
                  future: futureAlbum,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return Text('Title: ${snapshot.data!.title}');
                    } else if (snapshot.hasError) {
                      return Text('Error');
                    }
                    return Container(); // Return an empty container by default.
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<Ab> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    return Ab.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed');
  }
}
