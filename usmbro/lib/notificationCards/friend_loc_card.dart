import 'package:flutter/material.dart';

Card newFriendLocCard(String user) {
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
                onPressed: () {}),
          ],
        ),
      ],
    ),
  );
}
