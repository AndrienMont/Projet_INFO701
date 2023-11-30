import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:usmbro/get_users.dart';
import 'package:usmbro/mapController/control_map.dart';
import 'package:usmbro/notifications.dart';
import 'package:usmbro/post_users.dart';
//Import OSMFlutter

class MapUsers extends StatefulWidget {
  const MapUsers({super.key, required this.title});

  final String title;

  @override
  State<MapUsers> createState() => _MapUsersState();
}

class _MapUsersState extends State<MapUsers> {
  //Initialisation de la map
  late MapController mapController = controlMap();

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //       title: Text(widget.title),
    //     ),
    // );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(child: afficheMap(mapController)),
          ElevatedButton(
            onPressed: () async {
              // Appel de la fonction pour tracer la route
              await roadInfo(mapController);
            },
            child: Text('Tracer la route'),
          ),
        ],
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
