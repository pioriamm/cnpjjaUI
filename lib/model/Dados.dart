import 'package:proj_flutter/model/Email.dart';
import 'package:proj_flutter/model/Membo.dart';
import 'package:proj_flutter/model/Telefone.dart';
import 'package:proj_flutter/model/StatusEmpresa.dart';
import 'package:proj_flutter/model/Cnae.dart';

class Dados {
  final String? alias;
  final String? cnpjRaizId;
  final int? companiaId;
  final String? empresaRaiz;
  final List<Email>? email;
  final List<Telefone>? telefone;
  final StatusEmpresa? status;
  final Cnae? cnae;
  final List<Membro>? membros;

  Dados({
    this.alias,
    this.cnpjRaizId,
    this.companiaId,
    this.empresaRaiz,
    this.email,
    this.telefone,
    this.status,
    this.membros,
    this.cnae,
  });

  factory Dados.fromJson(Map<String, dynamic> json) {
    return Dados(
      alias: json['alias'],
      cnae: json['cnae'] != null ? Cnae.fromJson(json['cnae']) : null,
      cnpjRaizId: json['cnpj_raiz_id'],
      companiaId: json['compania_id'],
      empresaRaiz: json['empresa_raiz'],
      email: (json['email'] as List?)?.map((e) => Email.fromJson(e)).toList(),
      telefone: (json['telefone'] as List?)?.map((e) => Telefone.fromJson(e)).toList(),
      status: json['status'] != null ? StatusEmpresa.fromJson(json['status']) : null,
      membros: (json['membros'] as List?)?.map((e) => Membro.fromJson(e)).toList(),
    );
  }
}
