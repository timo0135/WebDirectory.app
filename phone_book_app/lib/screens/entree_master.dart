import 'package:flutter/material.dart';
import 'package:phone_book_app/models/entree.dart';
import 'package:phone_book_app/screens/api_services.dart';
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
    entrees = ApiService().fetchEntrees();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 243, 247, 1),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
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
                  setState(() {
                    if (value.isNotEmpty) {
                      entrees =
                          ApiService().searchEntrees(value, dropdownvalue!);
                    } else {
                      entrees = ApiService().fetchEntrees();
                      if (dropdownvalue != 'Tous') {
                        entrees = ApiService()
                            .filterEntrees(items.indexOf(dropdownvalue!));
                      }
                    }
                  });
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
            color: Colors.white,
            initialValue: dropdownvalue,
            icon: const Icon(
              Icons.filter_list,
              color: Color.fromRGBO(3, 148, 222, 1),
            ),
            onSelected: (String value) {
              setState(() {
                dropdownvalue = value;
                if (dropdownvalue == 'Tous') {
                  entrees = ApiService().fetchEntrees();
                } else {
                  entrees =
                      ApiService().filterEntrees(items.indexOf(dropdownvalue!));
                }
              });
            },
            popUpAnimationStyle: AnimationStyle(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 500),
            ),
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
                entrees = ApiService()
                    .sortEntrees(isAscending, items.indexOf(dropdownvalue!));
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Entree>>(
        future: entrees,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // ! Affichage des entrées
            return SizedBox(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final entree = snapshot.data![index];
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
}
