import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String nom;
  final String prenom;
  final String filiere;
  final String token;
  bool alreadyAdded;

  User(
      {required this.id,
      required this.nom,
      required this.prenom,
      required this.filiere, 
      required this.token,
      required this.alreadyAdded,
      });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["_id"],
        nom: json['nom'],
        prenom: json['prenom'],
        filiere: json['filiere'], 
        token: json['token'], 
        alreadyAdded: false);
  }


  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'filiere': filiere,
      'token': token,
    };
  }
}
