import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:proj_flutter/helprs/formatadores.dart';
import 'package:proj_flutter/model/prospec.dart';

import '../model/EmpresasConciliadora.dart';

class BuscarApiMongo {

  static Future<List<Prospectar>> buscarEmpresasBaseCnpjja() async {
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

  static Future<void> pesquisarCnpjja(String cnpj) async {

    final url = Uri.parse('${dotenv.env['API_URL']}/cnpjja/popularBase');
    var cnpjLimpo = Formatadores.limparCnpj(cnpj);
    final body = [{"cnpj": cnpjLimpo}];
    final response = await http.post(url, headers: {'Content-Type': 'application/json',},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro na pesquisa: ${response.statusCode} - ${response.body}',);
    }
  }

  static Future<List<EmpresasConciliadora>> buscarBaseConciliadora() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/empresas-conciliadora'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map<EmpresasConciliadora>((empresa) => EmpresasConciliadora.fromJson(empresa)).toList();
    } else {
      throw Exception('Erro ao buscar dados: ${response.statusCode}');
    }
  }
}
