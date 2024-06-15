import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:phone_book_app/models/entree.dart';
import 'package:http/http.dart' as http;

class EntreeDetails extends StatefulWidget {
  final String urlEntree;
  const EntreeDetails({super.key, required this.urlEntree});

  @override
  _EntreeDetailsState createState() => _EntreeDetailsState();
}

class _EntreeDetailsState extends State<EntreeDetails> {
  late Future<Entree> entreeDetails;

  @override
  void initState() {
    super.initState();
    entreeDetails = _fetchEntreeDetails(widget.urlEntree);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 243, 247, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(3, 148, 222, 1),
        title: const Text(
          'Détails de l\'entrée',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Entree>(
        future: entreeDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Aucune donnée disponible'));
          } else {
            final entree = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ! Photo de l'entrée
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(entree.image),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // ! Nom et prénom de l'entrée
                  Center(
                    child: Text(
                      '${entree.nom} ${entree.prenom}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // ! Boutons pour envoyer un email et appeler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(
                          color: Color.fromRGBO(3, 148, 222, 1),
                          Icons.phone,
                        ),
                        onPressed: () {
                          entree.callNumber(entree.numeroTel1!);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          color: Color.fromRGBO(3, 148, 222, 1),
                          Icons.email,
                        ),
                        onPressed: () {
                          entree.sendEmail(entree.email!);
                        },
                      ),
                    ],
                  ),
                  _buildInfoTile(
                      'Fonction', entree.fonction ?? 'Non renseigné'),
                  _buildInfoTile('Département', entree.departement.join(', ')),
                  _buildInfoTile('Bureau',
                      entree.numeroBureau?.toString() ?? 'Non renseigné'),
                  _buildInfoTile(
                      'Téléphone 1', entree.numeroTel1 ?? 'Non renseigné'),
                  _buildInfoTile(
                      'Téléphone 2', entree.numeroTel2 ?? 'Non renseigné'),
                  _buildInfoTile('Email', entree.email ?? 'Non renseigné'),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // ! Récupération d'une entrée détaillée depuis l'API
  Future<Entree> _fetchEntreeDetails(String id) async {
    final response = await http.get(Uri.parse(
        'http://docketu.iutnc.univ-lorraine.fr:54002/api/entrees/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Entree.fromJsonDetails(json);
    } else {
      throw Exception('Impossible de récupérer l\'entrée');
    }
  }

  // ! Fonction pour construire une ListTile
  Widget _buildInfoTile(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
