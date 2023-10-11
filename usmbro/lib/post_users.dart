import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  const User({required this.nom, required this.prenom, required this.filiere});

  Map<String, dynamic> toJson() => {
        'nom': nom,
        'prenom': prenom,
        'filiere': filiere,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        nom: json['nom'], prenom: json['prenom'], filiere: json['filiere']);
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
      Uri.parse("http://127.0.0.1;3000/api/users"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: User(nom: nom, prenom: prenom, filiere: filiere).toJson(),
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
            children: [
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
                      createUser(_controllerNom.text, _controllerPrenom.text,
                          _controllerFiliere.text);
                    });
                  },
                  child: const Text("Send to server"))
            ],
          ),
        ));
  }
}

// class UserTextFields extends StatelessWidget {
//   const UserTextFields({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SizedBox(
//           width: 100,
//           child: TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Nom',
//             ),
//           ),
//         ),
//         SizedBox(width: 15),
//         SizedBox(
//           width: 100,
//           child: TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Prénom',
//             ),
//           ),
//         ),
//         SizedBox(width: 15),
//         SizedBox(
//           width: 100,
//           child: TextField(
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               labelText: 'Filière',
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
