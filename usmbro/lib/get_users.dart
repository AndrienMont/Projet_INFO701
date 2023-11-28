
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usmbro/dataBaseHelper.dart';
import 'package:usmbro/map.dart';
import 'package:usmbro/mapController/control_map.dart';
import 'package:usmbro/user.dart';

import 'post_users.dart';


class GetUsers extends StatefulWidget {
  const GetUsers({super.key, required this.title});

  final String title;

  @override
  State<GetUsers> createState() => _GetUsers();
}

class _GetUsers extends State<GetUsers>{
   late SharedPreferences _prefs;
  List<User> usersList = [];

  @override
  void initState() {
    super.initState();
    _loadUserStatus();
  }

  Future<void> _loadUserStatus() async {
  _prefs = await SharedPreferences.getInstance();
  setState(() {
    // Mettez à jour l'état pour refléter si l'utilisateur a déjà été ajouté.
    usersList.forEach((user) {
      user.alreadyAdded = _prefs.getBool('userAlreadyAdded${user.id}') ?? false;
      print("User already added: ${user.alreadyAdded}");
      });
    });
  }

  Future<void> _saveUserStatus(User user, bool value) async {
    await _prefs.setBool('userAlreadyAdded${user.id}', value);
    setState(() {
      // Mettez à jour l'état pour refléter si l'utilisateur a déjà été ajouté.
      user.alreadyAdded = value;
    });
  }
  

  Future<void> getUsers() async {
    final response =
        await http.get(Uri.parse("http://10.7.148.83:3000/api/users"));

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
                  //getUsers();
                  print(controlMap().initPosition.toString());
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
                        bool userAlreadyAdded = _prefs.getBool('userAlreadyAdded${user.id}') ?? false;

                        return ListTile(
                          title: Text(user.nom),
                          subtitle: Text(user.prenom),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(user.filiere),
                              IconButton(
                                icon: Icon(
                                  Icons.person_add,
                                  color: userAlreadyAdded ? Colors.grey : Colors.green,
                                ),
                                onPressed: user.alreadyAdded
                                    ? null
                                    : () {
                                        User userBdd = User(
                                          id: user.id,
                                          nom: user.nom,
                                          prenom: user.prenom,
                                          filiere: user.filiere,
                                          token: user.token,
                                          alreadyAdded: true,
                                        );
                                        // Enregistrez l'utilisateur dans la base de données.
                                        DatabaseHelper.insertUser(userBdd);
                                        print("User added");
                                        // Mettez à jour les préférences partagées pour refléter que l'utilisateur est ajouté.
                                        _saveUserStatus(userBdd, true);
                                      },
                              ),

                              IconButton(
                                icon : Icon(
                                  userAlreadyAdded ? Icons.location_on : Icons.location_off,
                                  color: userAlreadyAdded ? Colors.red : Colors.grey,
                                ), onPressed: () {},
                              ),
                            ],
                          ),
                        );
                      },
                    ),),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
      onTap: (id) {
        if(id==0){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MapUsers(title: 'USMBRO home page'),
              allowSnapshotting: false,
            )
            );
        }else if(id==1){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GetUsers(title: 'USMBRO Get Page'),
              allowSnapshotting: false,
            ),
          );
        }else{
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostUsers(title: 'USMBRO Post Page'),
            allowSnapshotting: false,
          ),
          );
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',

        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.post_add),
          label: 'Post',

        ),
      ],
      ),
    );
  }
}