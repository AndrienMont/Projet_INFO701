import 'package:flutter/material.dart';
import 'package:usmbro/mapController/controlMap.dart';
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
    body: Center(
      child: SizedBox(
        width: const SizedBox.expand().width, 
        height: const SizedBox.expand().height, 
        child: afficheMap()),
    ),
    );
  }
}

