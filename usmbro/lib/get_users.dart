import 'dart:convert';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:usmbro/map.dart';
import 'package:usmbro/notifications.dart';
import 'package:usmbro/user.dart';

import 'post_users.dart';

class GetUsers extends StatefulWidget {
  const GetUsers({super.key, required this.title});

  final String title;

  @override
  State<GetUsers> createState() => _GetUsers();
}

class _GetUsers extends State<GetUsers> {
  List<User> usersList = [];
  late Socket socket;

  Future<void> getUsers() async {
    final response =
        await http.get(Uri.parse("http://192.168.33.22:3000/api/users"));

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

  void setSocket() {
    try {
      socket = io('http://192.168.33.22:8080', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'forceNew': true,
      });
      socket.connect();
      socket.on('connection', (_) {
        print('connecté');
      });
      socket.on('connect_timeout', (_) => print('connect_timeout'));
      socket.onError(
        (data) => print(data),
      );
    } catch (e) {
      print(e);
    }
  }

  void reqLoc(String tokenSen, String tokenRec) {
    var lat = "";
    var long = "";
    socket.emit('reqLoc', "$tokenSen $tokenRec");
    socket.on(tokenSen, (data) {
      lat = data.split(" ")[0];
      long = data.split(" ")[1];
      return GeoPoint(
          latitude: double.parse(lat), longitude: double.parse(long));
    });
  }

  @override
  void initState() {
    super.initState();
    setSocket();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {}, child: const Text("GET users")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const PostUsers(title: "POST users");
                      }));
                    },
                    child: const Text("POST users")),
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
