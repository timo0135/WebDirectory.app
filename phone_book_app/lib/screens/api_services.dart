import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:phone_book_app/models/entree.dart';

class ApiService {
  // * URL de base pour les requêtes
  static const String baseUrl = 'http://docketu.iutnc.univ-lorraine.fr:54002/api';

  // ! Récupération des entrées
  Future<List<Entree>> fetchEntrees() async {
    final response = await http.get(Uri.parse('$baseUrl/entrees?sort=nom-asc'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> entreesJson = json['entrees'];

      List<Entree> entrees = await Future.wait(
        entreesJson.map((json) async {
          Entree entree = Entree.fromJson(json);
          return await fetchEntreeDetails(entree.id!);
        }).toList(),
      );

      return entrees;
    } else {
      throw Exception('Impossible de récupérer les entrées');
    }
  }

  // ! Récupération des détails d'une entrée
  Future<Entree> fetchEntreeDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/entrees/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Entree.fromJsonDetails(json);
    } else {
      throw Exception('Impossible de récupérer les détails de l\'entrée');
    }
  }

  // ! Fonction de recherche d'entrées
  Future<List<Entree>> searchEntrees(String query, String department) async {
     String url;
    if (department == 'Tous') {
      url = '$baseUrl/entrees/search?q=$query';
    } else {
      url = '$baseUrl/services/2/entrees/search?q=$query';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> entreesJson = json['entrees'];

      List<Entree> entrees = await Future.wait(
        entreesJson.map((json) async {
          Entree entree = Entree.fromJson(json);
          return await fetchEntreeDetails(entree.id!);
        }).toList(),
      );

      return entrees;
    } else {
      throw Exception('Impossible de rechercher les entrées');
    }
  }

  // ! Fonction de trie des entrées
  Future<List<Entree>> sortEntrees(bool isAscending, int idDepartment) async {
    String url;
    if (idDepartment == 0) {
      url = '$baseUrl/entrees?sort=nom-${isAscending ? 'asc' : 'desc'}';
    } else {
      url = '$baseUrl/services/$idDepartment/entrees?sort=nom-${isAscending ? 'asc' : 'desc'}';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> entreesJson = json['entrees'];

      List<Entree> entrees = await Future.wait(
        entreesJson.map((json) async {
          Entree entree = Entree.fromJson(json);
          return await fetchEntreeDetails(entree.id!);
        }).toList(),
      );

      return entrees;
    } else {
      throw Exception('Impossible de trier les entrées');
    }
  }

  // ! Fonction de filtrage des entrées par département
  Future<List<Entree>> filterEntrees(int idDepartment) async {
    final response = await http.get(Uri.parse('$baseUrl/services/$idDepartment/entrees'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> entreesJson = json['entrees'];

      List<Entree> entrees = await Future.wait(
        entreesJson.map((json) async {
          Entree entree = Entree.fromJson(json);
          return await fetchEntreeDetails(entree.id!);
        }).toList(),
      );

      return entrees;
    } else {
      throw Exception('Impossible de filtrer les entrées');
    }
  }
}
