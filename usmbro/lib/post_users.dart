import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usmbro/get_users.dart';
import 'package:usmbro/map.dart';
import 'package:usmbro/notifications.dart';
import 'package:uuid/uuid.dart';

class PostUsers extends StatefulWidget {
  const PostUsers({super.key, required this.title});

  final String title;

  @override
  State<PostUsers> createState() => _PostUsersState();
}

class UserPost {
  final String nom;
  final String prenom;
  final String filiere;
  final String token;

  const UserPost(
      {required this.nom,
      required this.prenom,
      required this.filiere,
      required this.token});

  Map<String, dynamic> toJson() =>
      {'nom': nom, 'prenom': prenom, 'filiere': filiere, 'token': token};

  factory UserPost.fromJson(Map<String, dynamic> json) {
    return UserPost(
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

  void _storeUuid(String token, String pren) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('uuid', token);
      prefs.setString('prenom', pren);
    });
  }

  Future<void> createUser(String nom, String prenom, String filiere) async {
    String token = const Uuid().v4();
    final response = await http.post(
      Uri.parse("http://192.168.33.22:3000/api/users/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(UserPost(
          nom: nom.toUpperCase(),
          prenom: prenom,
          filiere: filiere.toUpperCase(),
          token: token)),
    );
    _storeUuid(token, prenom);
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
                          createUser(_controllerNom.text,
                              _controllerPrenom.text, _controllerFiliere.text);
                        });
                      },
                      child: const Text("Send to server")),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.black,
        onTap: (id) {
          if (id == 0) {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const MapUsers(title: 'USMBRO home page'),
                  allowSnapshotting: false,
                ));
          } else if (id == 1) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GetUsers(title: 'USMBRO Get Page'),
                allowSnapshotting: false,
              ),
            );
          } else if (id == 2) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const PostUsers(title: 'USMBRO Post Page'),
                allowSnapshotting: false,
              ),
            );
          } else {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const Notifications(title: 'USMBRO Notifications Page'),
                allowSnapshotting: false,
              ),
            );
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.black),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add, color: Colors.black),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.black),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
