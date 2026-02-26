import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/model/prospec.dart';

import '../model/empresas_conciliadora.dart';

class ApiService {
  static Future<List<Prospectar>> buscarEmpresasBaseCnpjja() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/mongo/buscarDados'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map<Prospectar>((empresa) => Prospectar.fromJson(empresa))
          .toList();
    } else {
      throw Exception('Erro ao buscar dados: ${response.statusCode}');
    }
  }

  static Future<int> pesquisarCnpjja(String cnpj) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/cnpjja/popularBase');

    var cnpjLimpo = Formatadores.limparCnpj(cnpj);
    print("realizando chamada no endpoint ${url}");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode([
        {"cnpj": cnpjLimpo}
      ]),
    );
    print("resultado ${response.body}");
    return response.statusCode;
  }

  static Future<List<EmpresasConciliadora>> buscarBaseConciliadora() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/empresas-conciliadora'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map<EmpresasConciliadora>(
            (empresa) => EmpresasConciliadora.fromJson(empresa),
          )
          .toList();
    } else {
      throw Exception('Erro ao buscar dados: ${response.statusCode}');
    }
  }

  static Future<int> atualizarStatusEmpresa(String? id) async {

    final baseUrl = dotenv.env['API_URL']!;

    print("atualizando o  id :  ${id}");

    final url = Uri.parse(
      '$baseUrl/empresas-conciliadora/$id/pesquisado',
    );

    print('PUT -> $url');

    final response = await http.put(url);
    print("atualizando o  id :  ${response}");
    return response.statusCode;
  }
}
