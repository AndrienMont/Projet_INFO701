import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class User {
  final String nom;
  final String prenom;
  final String filiere;

  const User({required this.nom, required this.prenom, required this.filiere});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        nom: json['nom'], prenom: json['prenom'], filiere: json['filiere']);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'USMBRO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'USMBRO home page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<User> getUsers() async {
    final response =
        await http.get(Uri.parse("http://10.7.144.78:3000/api/users"));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Erreur lors de la récupération des utilisateurs");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Liste des utilisateurs:',
            ),
            ElevatedButton(
                onPressed: () {
                  getUsers();
                },
                child: const Text("Récupérer la liste des utilisateurs"))
          ],
        ),
      ),
    );
  }
}
