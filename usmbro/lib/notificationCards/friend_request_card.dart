import 'package:flutter/material.dart';

Card newFriendReqCard(String user) {
  String name = user.toUpperCase();
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Demande d\'ami'),
          subtitle: Text('$name vous a demandé en ami'),
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
        )
      ],
    ),
  );
}
