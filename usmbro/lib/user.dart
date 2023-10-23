class User {
  final String id;
  final String nom;
  final String prenom;
  final String filiere;

  const User(
      {required this.id,
      required this.nom,
      required this.prenom,
      required this.filiere});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["_id"],
        nom: json['nom'],
        prenom: json['prenom'],
        filiere: json['filiere']);
  }
}