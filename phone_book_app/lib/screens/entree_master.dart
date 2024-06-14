import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:phone_book_app/models/entree.dart';
import 'package:phone_book_app/screens/entree_preview.dart';

class EntreeMaster extends StatefulWidget {
  const EntreeMaster({super.key});

  @override
  State<EntreeMaster> createState() => _EntreeMasterState();
}

class _EntreeMasterState extends State<EntreeMaster> {
  // ! Attributs
  late Future<List<Entree>> entrees; // * Liste des entrées
  String? dropdownvalue = 'Tous'; // * Valeur du menu déroulant
  var items = [
    'Tous',
    'Ressources Humaines',
    'Informatique',
    'Marketing',
    'Finance',
    'Support Client'
  ]; // * Éléments du menu déroulant

  bool isAscending = true; // * Variable pour le tri des entrées
  bool isSearching = false; // * Variable pour l'état de la recherche
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    entrees = _fetchEntrees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 243, 247, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Color.fromRGBO(3, 148, 222, 1),
          ),
          onPressed: () {},
        ),
        title: !isSearching
            ? const Text(
                '',
                style: TextStyle(color: Color.fromRGBO(3, 148, 222, 1)),
              )
            : TextField(
                controller: searchController,
                style: const TextStyle(color: Color.fromRGBO(3, 148, 222, 1)),
                decoration: const InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(color: Color.fromRGBO(3, 148, 222, 1)),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
        actions: <Widget>[
          // ! Bouton pour activer/désactiver la recherche
          IconButton(
            icon: Icon(
              isSearching ? Icons.clear : Icons.search,
              color: const Color.fromRGBO(3, 148, 222, 1),
            ),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                }
                isSearching = !isSearching;
              });
            },
          ),
          // ! Menu déroulant pour filtrer par département
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.filter_list,
              color: Color.fromRGBO(3, 148, 222, 1),
            ),
            onSelected: (String value) {
              setState(() {
                dropdownvalue = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return items.map<PopupMenuItem<String>>((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
          ),
          // ! Bouton pour trier les entrées par nom (ascendant/descendant)
          IconButton(
            icon: const Icon(
              Icons.sort_by_alpha,
              color: Color.fromRGBO(3, 148, 222, 1),
            ),
            onPressed: () {
              setState(() {
                isAscending = !isAscending;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Entree>>(
        future: entrees,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // ! Filtrer des entrées par département et par recherche
            List<Entree> filteredEntrees = _filterEntrees(snapshot.data!);
            filteredEntrees =
                _searchEntrees(filteredEntrees, searchController.text);

            // ! Tri des entrées par nom
            filteredEntrees.sort((a, b) =>
                isAscending ? a.nom.compareTo(b.nom) : b.nom.compareTo(a.nom));

            // ! Affichage des entrées
            return Expanded(
              child: ListView.builder(
                itemCount: filteredEntrees.length,
                itemBuilder: (context, index) {
                  final entree = filteredEntrees[index];
                  return EntreePreview(entree: entree);
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('ERREUR: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // ! Récupération des entrées depuis l'API
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

  // ! Filtrer des entrées par département
  List<Entree> _filterEntrees(List<Entree> entrees) {
    if (dropdownvalue == 'Tous') {
      return entrees;
    } else {
      return entrees
          .where((entree) => entree.departement.contains(dropdownvalue))
          .toList();
    }
  }

  // ! Filtrer des entrées par recherche
  List<Entree> _searchEntrees(List<Entree> entrees, String query) {
    if (query.isEmpty) {
      return entrees;
    } else {
      return entrees.where((entree) {
        return entree.nom.toLowerCase().contains(query.toLowerCase()) ||
            entree.prenom.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}
