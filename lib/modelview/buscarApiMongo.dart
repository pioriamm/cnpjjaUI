import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:proj_flutter/model/prospec.dart';

class BuscarApiMongo {
  static Future<List<Prospectar>> buscarDadosMongo() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/mongo/buscarDados'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map<Prospectar>((empresa) => Prospectar.fromJson(empresa)).toList();
    } else {
      throw Exception('Erro ao buscar dados: ${response.statusCode}');
    }
  }
}
