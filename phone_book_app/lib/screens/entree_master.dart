import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:phone_book_app/models/entree.dart';

class EntreeMaster extends StatefulWidget {
  const EntreeMaster({super.key});

  @override
  State<EntreeMaster> createState() => _EntreeMasterState();
}

class _EntreeMasterState extends State<EntreeMaster> {
  late Future<List<Entree>> entrees;

  @override
  void initState() {
    super.initState();
    entrees = _fetchEntrees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 243, 247, 1),
      body: FutureBuilder<List<Entree>>(
        future: entrees,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Tri des entrées par nom
            snapshot.data!.sort((a, b) => a.nom.compareTo(b.nom));

            // Affichage des entrées
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final entree = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            entree.image), // Chargement de l'image depuis l'URL
                      ),
                      title: Text('${entree.nom} ${entree.prenom}'),
                      subtitle: Text(entree.departement.join(', ')),
                      trailing: const Icon(
                        Icons.phone_outlined,
                        color: Color.fromRGBO(3, 148, 222, 1),
                        
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('ERREUR: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // Récupération des entrées depuis l'API
  Future<List<Entree>> _fetchEntrees() async {
    final response = await http.get(
        Uri.parse('http://docketu.iutnc.univ-lorraine.fr:54002/api/entrees'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> entreesJson = json['entrees'];
      return entreesJson.map<Entree>((json) {
        return Entree.fromJson(json['entree'] as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception('Impossible de récupérer les entrées');
    }
  }
}
