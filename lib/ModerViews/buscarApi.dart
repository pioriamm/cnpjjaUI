import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/prospectar.dart';

class BuscarApi {

  static Future<List<Prospectar>> buscarDadosApi() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/v1/pesquisar/buscarDados'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList
          .map((empresa) => Prospectar.fromJson(empresa))
          .toList();
    } else {
      throw Exception('Erro ao buscar dados: ${response.statusCode}');
    }
  }
}
