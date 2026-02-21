

import 'package:proj_flutter/model/EmpresaSocio.dart';

class Membro {
  final String? idMembro;
  final String? nomeMembro;
  final List<EmpresaSocio>? empresas;

  Membro({this.idMembro, this.nomeMembro, this.empresas});

  factory Membro.fromJson(Map<String, dynamic> json) {
    return Membro(
      idMembro: json['id_membro'],
      nomeMembro: json['nome_membro'],
      empresas: (json['empresas'] as List?)?.map((e) => EmpresaSocio.fromJson(e)).toList(),
    );
  }
}