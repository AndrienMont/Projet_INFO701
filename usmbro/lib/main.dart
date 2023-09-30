import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

void main() {
  runApp(const MyApp());
}

class User {
  final String id;
  final String nom;
  final String prenom;
  final String filiere;

  const User(
      {required this.id,
      required this.nom,
      required this.prenom,
      required this.filiere});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["_id"],
        nom: json['nom'],
        prenom: json['prenom'],
        filiere: json['filiere']);
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
  List<User> usersList = [];

  Future<void> getUsers() async {
    final response =
        await http.get(Uri.parse("http://192.168.1.7:3000/api/users"));

    developer.log(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<User> users = jsonList.map((e) => User.fromJson(e)).toList();
      setState(() {
        usersList = users;
      });
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
            ElevatedButton(
                onPressed: () {
                  getUsers();
                },
                child: const Text("Récupérer la liste des utilisateurs")),
            const Text(
              'Liste des utilisateurs:',
            ),
            Expanded(
                child: usersList.isEmpty
                    ? const Text("Aucun utilisateur")
                    : ListView.builder(
                        itemCount: usersList.length,
                        itemBuilder: (context, index) {
                          final user = usersList[index];
                          return ListTile(
                            title: Text(user.nom),
                            subtitle: Text(user.prenom),
                            trailing: Text(user.filiere),
                          );
                        },
                      )),
          ],
        ),
      ),
    );
  }
}
