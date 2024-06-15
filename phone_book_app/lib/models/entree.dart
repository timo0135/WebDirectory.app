import 'package:url_launcher/url_launcher.dart';

class Entree {
  // ! Attributs
  String nom, prenom, image;
  String? id, fonction, numeroTel1, numeroTel2, email;
  int? numeroBureau;
  List<String> departement;

  // ! Constructeur
  Entree({
    this.id,
    required this.nom,
    required this.prenom,
    required this.departement,
    this.image = "http://docketu.iutnc.univ-lorraine.fr:54002/img/person.png",
    this.fonction,
    this.numeroBureau,
    this.numeroTel1,
    this.numeroTel2,
    this.email,
  });

  // ! Création d'une Entree à partir d'un objet JSON
  factory Entree.fromJson(Map<String, dynamic> json) {
    String url = json['links']['self']['href'] as String;
    String id = url.split('/').last;
    
    return Entree(
      id: id,
      nom: json['entree']['nom'] as String,
      prenom: json['entree']['prenom'] as String,
      departement: List<String>.from(json['entree']['departement'] as List),
    );
  }

  // ! Création d'une Entree à partir d'un objet JSON détaillé
  factory Entree.fromJsonDetails(Map<String, dynamic> json) {
    return Entree(
      id: json['entree']['id'] as String,
      nom: json['entree']['nom'] as String,
      prenom: json['entree']['prenom'] as String,
      departement: List<String>.from(json['entree']['departement'] as List),
      fonction: json['entree']['fonction'] as String,
      numeroBureau: json['entree']['numeroBureau'] as int,
      numeroTel1: json['entree']['numeroTel1'] as String,
      numeroTel2: json['entree']['numeroTel2'],
      email: json['entree']['email'] as String,
      image:
          "http://docketu.iutnc.univ-lorraine.fr:54002${json['links']['image']}",
    );
  }

   // ! Fonctions pour lancer un appel 
  Future<void> callNumber(String num) async {
    final Uri tel = Uri.parse("tel:$num");

    await launchUrl(tel)
        ? ''
        : throw Exception('Impossible de lancer l\'appel $tel');
  }

  // ! Fonctions pour envoyer un email 
  Future<void> sendEmail(String email) async {
    final Uri mail = Uri.parse("mailto:$email");

    await launchUrl(mail)
        ? ''
        : throw Exception('Impossible de lancer l\'email $mail');
  }

}
