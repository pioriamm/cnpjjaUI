class Prospectar {
  final String? id;
  final List<Dados>? dados;

  Prospectar({this.id, this.dados});

  factory Prospectar.fromJson(Map<String, dynamic> json) {
    return Prospectar(
      id: json['id'],
      dados: json['dados'] != null
          ? (json['dados'] as List)
          .map((e) => Dados.fromJson(e))
          .toList()
          : null,
    );
  }
}

class Dados {
  final String? alias;
  final String? cnpjRaizId;
  final int? companiaId;
  final String? empresaRaiz;
  final List<Email>? email;
  final List<Telefone>? telefone;
  final Status? status;
  final List<Membro>? membros;
  final List<EmpresaSocio>? empresas;

  Dados({
    this.alias,
    this.cnpjRaizId,
    this.companiaId,
    this.empresaRaiz,
    this.email,
    this.telefone,
    this.status,
    this.membros,
    this.empresas,
  });

  factory Dados.fromJson(Map<String, dynamic> json) {
    return Dados(
      alias: json['alias'],
      cnpjRaizId: json['cnpj_raiz_id'],
      companiaId: json['compania_id'],
      empresaRaiz: json['empresa_raiz'],
      email: json['email'] != null
          ? (json['email'] as List)
          .map((e) => Email.fromJson(e))
          .toList()
          : null,
      telefone: json['telefone'] != null
          ? (json['telefone'] as List)
          .map((e) => Telefone.fromJson(e))
          .toList()
          : null,
      status:
      json['status'] != null ? Status.fromJson(json['status']) : null,
      membros: json['membros'] != null
          ? (json['membros'] as List)
          .map((e) => Membro.fromJson(e))
          .toList()
          : null,
      empresas: json['empresas'] != null
          ? (json['empresas'] as List)
          .map((e) => EmpresaSocio.fromJson(e))
          .toList()
          : null,
    );
  }
}

class Email {
  final String? address;

  Email({this.address});

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      address: json['address'],
    );
  }
}

class Telefone {
  final String? area;
  final String? number;

  Telefone({this.area, this.number});

  factory Telefone.fromJson(Map<String, dynamic> json) {
    return Telefone(
      area: json['area'],
      number: json['number'],
    );
  }
}

class Status {
  final String? text;

  Status({this.text});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      text: json['text'],
    );
  }

  @override
  String toString() => text ?? '';
}

class Membro {
  final String? idMembro;
  final String? nomeMembro;
  final List<EmpresaSocio>? empresas;

  Membro({
    this.idMembro,
    this.nomeMembro,
    this.empresas,
  });

  factory Membro.fromJson(Map<String, dynamic> json) {
    return Membro(
      idMembro: json['id_membro'],
      nomeMembro: json['nome_membro'],
      empresas: (json['empresas'] as List?)
          ?.map((e) => EmpresaSocio.fromJson(e))
          .toList(),
    );
  }
}


class EmpresaSocio {
  final String? idEmpresaSocio;
  final String? nomeEmpresaSocio;
  final List<Person>? membrosEmpresaSocio;

  EmpresaSocio({
    this.idEmpresaSocio,
    this.nomeEmpresaSocio,
    this.membrosEmpresaSocio,
  });

  factory EmpresaSocio.fromJson(Map<String, dynamic> json) {
    return EmpresaSocio(
      idEmpresaSocio: json['id_empresa_socio'],
      nomeEmpresaSocio: json['nome_empresa_socio'],
      membrosEmpresaSocio: json['membros_empresa_socio'] != null
          ? (json['membros_empresa_socio'] as List)
          .map((e) => Person.fromJson(e))
          .toList()
          : null,
    );
  }
}

class Person {
  final String? id;
  final String? name;
  final String? age;

  Person({this.id, this.name, this.age});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['_id'],
      name: json['name'],
      age: json['age'],
    );
  }
}
