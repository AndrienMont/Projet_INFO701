import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart';

Card newFriendLocCard(String user, String token, Position loc) {
  Socket socket = io('http://192.168.159.22:8080', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'forceNew': true,
  });
  socket.connect();
  String name = user.toUpperCase();
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.map),
          title: const Text('Demande de localisation'),
          subtitle: Text('$name a demandé à vous localiser'),
        ),
        ButtonBar(
          children: <Widget>[
            TextButton(
                child: const Text("Refuser",
                    style: TextStyle(color: Colors.redAccent)),
                onPressed: () {}),
            TextButton(
                child: const Text("Accepter",
                    style: TextStyle(color: Colors.green)),
                onPressed: () {
                  socket.emit(token, "${loc.latitude} ${loc.longitude}");
                  // callback();
                }),
          ],
        ),
      ],
    ),
  );
}
