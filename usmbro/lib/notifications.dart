import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final channel =
      WebSocketChannel.connect(Uri.parse("ws://192.168.72.22:3000"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: const Center(
          child: Text('Notifications'),
        ));
  }
}
