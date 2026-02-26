import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class ApiService {
  Future<List<Pokemon>> fetchPokemons() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=20'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Pokemon.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar datos');
    }
  }
}