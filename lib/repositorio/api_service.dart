import 'dart:convert';

import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/model/prospec.dart';
import 'package:cnpjjaUi/model/response_page.dart';
import 'package:cnpjjaUi/modelview/buscar_base_cnpja_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/empresas_conciliadora.dart';

class ApiService {
  static Future<int> pesquisarCnpjja(String cnpj) async {
    try {
      final baseUrl = dotenv.env['API_URL'];

      if (baseUrl == null || baseUrl.isEmpty) {
        throw Exception('API_URL não configurada no .env');
      }

      final url = Uri.parse('$baseUrl/cnpjja/popularBase');

      final cnpjLimpo = Formatadores.limparCnpj(cnpj);

      if (cnpjLimpo.isEmpty) {
        throw Exception('CNPJ inválido');
      }

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode([
          {"cnpj": cnpjLimpo},
        ]),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.statusCode;
      } else {
        throw Exception(
          'Erro na API: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Falha ao pesquisar CNPJ: $e');
    }
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

    final url = Uri.parse('$baseUrl/empresas-conciliadora/$id/pesquisado');
    final response = await http.put(url);
    return response.statusCode;
  }

  static Future<ResponsePage<Prospectar>> buscarEmpresasBaseCnpjja({
    required int page,
    required int size,
  }) async {
    final url = Uri.parse(
      '${dotenv.env['API_URL']}/mongo/buscarDados?page=$page&size=$size',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);

      var result = ResponsePage<Prospectar>.fromJson(
        jsonMap,
        (e) => Prospectar.fromJson(e),
      );

      return result;
    } else {
      throw Exception("Erro ao buscar empresas");
    }
  }
}
