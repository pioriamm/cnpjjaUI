

import 'package:cnpjjaUi/model/empresa_socio.dart';

class Membros {
  final String? idMembro;
  final String? nomeMembro;
  final List<EmpresaSocio>? empresas;

  Membros({this.idMembro, this.nomeMembro, this.empresas});

  factory Membros.fromJson(Map<String, dynamic> json) {
    return Membros(
      idMembro: json['id_membro'],
      nomeMembro: json['nome_membro'],
      empresas: (json['empresas'] as List?)?.map((e) => EmpresaSocio.fromJson(e)).toList(),
    );
  }
}