import 'package:cnpjjaUi/model/Email.dart';
import 'package:cnpjjaUi/model/Telefone.dart';
import 'package:cnpjjaUi/model/StatusEmpresa.dart';
import 'package:cnpjjaUi/model/Cnae.dart';
import 'package:cnpjjaUi/model/person.dart';

class EmpresaSocio {
  final String? idEmpresaSocio;
  final String? nomeEmpresaSocio;
  final String? cnpjEmpresaSocio;
  final Cnae cnae;

  final List<Person>? membrosEmpresaSocio;
  final List<Telefone>? telefone;
  final List<Email>? email;
  final StatusEmpresa? status;

  EmpresaSocio({
    this.idEmpresaSocio,
    this.nomeEmpresaSocio,
    this.cnpjEmpresaSocio,
    this.membrosEmpresaSocio,
    this.telefone,
    this.email,
    this.status,
    required this.cnae,
  });

  factory EmpresaSocio.fromJson(Map<String, dynamic> json) {
    return EmpresaSocio(
      idEmpresaSocio: json['id_empresa_socio'],
      nomeEmpresaSocio: json['nome_empresa_socio'],
      cnpjEmpresaSocio: json['cnpj_empresa_socio'],
      membrosEmpresaSocio: (json['membros_empresa_socio'] as List?)?.map((e) => Person.fromJson(e)).toList(),
      telefone: (json['telefone'] as List?)?.map((e) => Telefone.fromJson(e)).toList(),
      email: (json['email'] as List?)?.map((e) => Email.fromJson(e)).toList(),
      status: json['status'] != null ? StatusEmpresa.fromJson(json['status']) : null,
      cnae: json['cnae'] != null ? Cnae.fromJson(json['cnae']) : Cnae(),
    );
  }
}
