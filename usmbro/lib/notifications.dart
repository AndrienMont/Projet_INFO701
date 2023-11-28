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

  void getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenU = prefs.getString('uuid');
    token = tokenU!;
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

  void sendTest() {
    socket.emit('salut', 'c\' est un test');
  }

  void deco() {
    socket.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            newFriendLocCard("test"),
            newFriendReqCard("test"),
            ElevatedButton(
                onPressed: setSocket, child: const Text("Connexion")),
            ElevatedButton(onPressed: sendTest, child: const Text("test")),
            ElevatedButton(onPressed: deco, child: const Text("Deconnexion")),
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
