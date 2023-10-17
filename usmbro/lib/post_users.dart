import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:usmbro/main.dart';
import 'package:usmbro/map.dart';
import 'package:uuid/uuid.dart';

class PostUsers extends StatefulWidget {
  const PostUsers({super.key, required this.title});

  final String title;

  @override
  State<PostUsers> createState() => _PostUsersState();
}

class User {
  final String nom;
  final String prenom;
  final String filiere;
  final String token;

  const User(
      {required this.nom,
      required this.prenom,
      required this.filiere,
      required this.token});

  Map<String, dynamic> toJson() =>
      {'nom': nom, 'prenom': prenom, 'filiere': filiere, 'token': token};

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        nom: json['nom'],
        prenom: json['prenom'],
        filiere: json['filiere'],
        token: json['token']);
  }
}

class _PostUsersState extends State<PostUsers> {
  final TextEditingController _controllerNom = TextEditingController();
  final TextEditingController _controllerPrenom = TextEditingController();
  final TextEditingController _controllerFiliere = TextEditingController();
  String nomPost = "";
  String prenomPost = "";
  String filierePost = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controllerNom.dispose();
    _controllerPrenom.dispose();
    _controllerFiliere.dispose();
    super.dispose();
  }

  Future<void> createUser(String nom, String prenom, String filiere) async {
    final response = await http.post(
      Uri.parse("http://192.168.72.22:3000/api/users/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(User(
          nom: nom.toUpperCase(),
          prenom: prenom,
          filiere: filiere.toUpperCase(),
          token: const Uuid().v4())),
    );
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      const Text("User created");
    } else {
      throw Exception('Failed to create user.');
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
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _controllerNom,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Nom',
                            ),
                            onSubmitted: (value) => nomPost = value,
                          ),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _controllerPrenom,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Prénom',
                            ),
                            onSubmitted: (value) => prenomPost = value,
                          ),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: _controllerFiliere,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Filière',
                            ),
                            onSubmitted: (value) => filierePost = value,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            createUser(
                                _controllerNom.text,
                                _controllerPrenom.text,
                                _controllerFiliere.text);
                          });
                        },
                        child: const Text("Send to server")),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const MyHomePage(title: "USMBRO Home Page");
                        }));
                      },
                      child: const Text("GET users")),
                  ElevatedButton(
                      onPressed: () {}, child: const Text("POST users")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const MapUsers(title: "Map Users");
                        }));
                      },
                      child: const Text("MAP")),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
