import 'package:flutter/material.dart';
import 'package:usmbro/get_users.dart';
import 'package:usmbro/mapController/control_map.dart';
import 'package:usmbro/post_users.dart';
//Import OSMFlutter


class MapUsers extends StatefulWidget {
  const MapUsers({super.key, required this.title});

  final String title;

  @override
  State<MapUsers> createState() => _MapUsersState();
}


class _MapUsersState extends State<MapUsers> {
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
    body: SizedBox(
        width: const SizedBox.expand().width, 
        height: const SizedBox.expand().height, 
        child: afficheMap()),
    bottomNavigationBar: BottomNavigationBar(
      onTap: (id) {
        if(id==0){
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MapUsers(title: 'USMBRO home page'),
              allowSnapshotting: false,
            ),
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
            MaterialPageRoute(
              builder: (context) => const PostUsers(title: 'USMBRO Post Page'),
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

