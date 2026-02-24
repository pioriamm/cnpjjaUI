import 'Cnae.dart';
import 'Email.dart';
import 'Membo.dart';
import 'StatusEmpresa.dart';
import 'Telefone.dart';

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
      alias: json['alias'] as String?,

      cnae: json['cnae'] != null
          ? Cnae.fromJson(json['cnae'] as Map<String, dynamic>)
          : null,

      cnpjRaizId: json['cnpj_raiz_id'] as String?,
      companiaId: json['compania_id'] as int?,
      empresaRaiz: json['empresa_raiz'] as String?,

      /// ✅ EMAIL TIPADO
      email: (json['email'] as List<dynamic>?)
          ?.map<Email>((e) =>
          Email.fromJson(e as Map<String, dynamic>))
          .toList(),

      /// ✅ TELEFONE TIPADO
      telefone: (json['telefone'] as List<dynamic>?)
          ?.map<Telefone>((e) =>
          Telefone.fromJson(e as Map<String, dynamic>))
          .toList(),

      status: json['status'] != null
          ? StatusEmpresa.fromJson(
          json['status'] as Map<String, dynamic>)
          : null,

      /// ✅ MEMBROS TIPADO (AQUI ESTAVA O PROBLEMA)
      membros: (json['membros'] as List<dynamic>?)
          ?.map<Membro>((e) =>
          Membro.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}