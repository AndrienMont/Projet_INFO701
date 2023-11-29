import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:usmbro/get_users.dart';
import 'package:usmbro/map.dart';
import 'package:usmbro/notificationCards/friend_loc_card.dart';
import 'package:usmbro/notificationCards/friend_request_card.dart';
import 'package:usmbro/post_users.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late Socket socket;
  String token = "";
  String prenom = "";

  void getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenU = prefs.getString('uuid');
    String? prenomU = prefs.getString('prenom');
    token = tokenU!;
    prenom = prenomU!;
    print(token);
  }

  void getLoc() async {
    var location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(location);
  }

  @override
  void initState() {
    super.initState();
    // printLoc();
    getLoc();
    getToken();
    setSocket();
  }

  void setSocket() {
    socket = io('http://192.168.159.22:8080', <String, dynamic>{
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
  }

  void sendTest() {
    socket.emit('salut', 'c\' est un test');
  }

  void deco() {
    socket.disconnect();
  }

  Future<Card?> askLoc() async {
    print("here");
    var nom = "";
    var tokenU = "";

    socket = io('http://192.168.159.22:8080', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
    });
    socket.connect();
    print(socket.connected);
    var location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(token);
    print(socket.connected);
    socket.on("salut", (data) {
      print("here");
      tokenU = data.split(" ")[0];
      print(tokenU);
      nom = data.split(" ")[1];
      print(nom);
      return newFriendLocCard(nom, location, tokenU);
    });

    Timer(const Duration(seconds: 30), () {
      print("finito");
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<Card?> ask() async {
      return await askLoc().timeout(const Duration(seconds: 30));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Notifications'),
      ),
      body: Center(
        child: FutureBuilder<Card?>(
          future: ask(),
          builder: (BuildContext context, AsyncSnapshot<Card?> snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const Text("Pas de notifications.");
            }
          },
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
