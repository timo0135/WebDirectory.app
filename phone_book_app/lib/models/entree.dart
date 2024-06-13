class Entree {
  // Attributs
  String nom;
  String prenom;
  List<String> departement;
  String image;

  // Constructeur
  Entree({
    required this.nom,
    required this.prenom,
    required this.departement,
    this.image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3HdBqVDU45zUIDYvJbH1QE2kosJ0VrH0KEXee3n33PnskjPbyvDAUWYrChTGjCXHA2cc&usqp=CAU",
  });

  // Création d'une Entree à partir d'un objet JSON
  factory Entree.fromJson(Map<String, dynamic> json) {
    return Entree(
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      departement: List<String>.from(json['departement'] as List),
    );
  }
}
