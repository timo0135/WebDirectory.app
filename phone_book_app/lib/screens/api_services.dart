import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:phone_book_app/models/entree.dart';

class ApiService {
  static const String baseUrl = 'http://docketu.iutnc.univ-lorraine.fr:54002/api/entrees';

  Future<List<Entree>> fetchEntrees() async {
    final response = await http.get(Uri.parse(baseUrl));

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

  Future<Entree> fetchEntreeDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      return Entree.fromJsonDetails(json);
    } else {
      throw Exception('Impossible de récupérer les détails de l\'entrée');
    }
  }
}
