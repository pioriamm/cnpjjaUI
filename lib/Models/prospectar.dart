class Prospectar {
  final String? id;
  final List<Dados>? dados;

  Prospectar({this.id, this.dados});

  factory Prospectar.fromJson(Map<String, dynamic> json) {
    return Prospectar(
      id: json['id'],
      dados: (json['dados'] as List?)
          ?.map((e) => Dados.fromJson(e))
          .toList(),
    );
  }
}

// =====================================================
// DADOS EMPRESA RAIZ
// =====================================================

class Dados {
  final String? alias;
  final String? cnpjRaizId;
  final int? companiaId;
  final String? empresaRaiz;
  final List<Email>? email;
  final List<Telefone>? telefone;
  final Status? status;
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
  });

  factory Dados.fromJson(Map<String, dynamic> json) {
    return Dados(
      alias: json['alias'],
      cnpjRaizId: json['cnpj_raiz_id'],
      companiaId: json['compania_id'],
      empresaRaiz: json['empresa_raiz'],
      email: (json['email'] as List?)
          ?.map((e) => Email.fromJson(e))
          .toList(),
      telefone: (json['telefone'] as List?)
          ?.map((e) => Telefone.fromJson(e))
          .toList(),
      status:
      json['status'] != null ? Status.fromJson(json['status']) : null,
      membros: (json['membros'] as List?)
          ?.map((e) => Membro.fromJson(e))
          .toList(),
    );
  }
}

// =====================================================
// EMAIL
// =====================================================

class Email {
  final String? address;
  final String? domain;
  final String? ownership;

  Email({this.address, this.domain, this.ownership});

  factory Email.fromJson(Map<String, dynamic> json) {
    return Email(
      address: json['address'],
      domain: json['domain'],
      ownership: json['ownership'],
    );
  }
}

// =====================================================
// TELEFONE
// =====================================================

class Telefone {
  final String? area;
  final String? number;
  final String? type;

  Telefone({this.area, this.number, this.type});

  factory Telefone.fromJson(Map<String, dynamic> json) {
    return Telefone(
      area: json['area'],
      number: json['number'],
      type: json['type'],
    );
  }
}

// =====================================================
// STATUS
// =====================================================

class Status {
  final int? id;
  final String? text;

  Status({this.id, this.text});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'],
      text: json['text'],
    );
  }

  @override
  String toString() => text ?? '';
}

// =====================================================
// MEMBRO
// =====================================================

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

// =====================================================
// EMPRESA DO SOCIO (🔥 PRINCIPAL ALTERAÇÃO)
// =====================================================

class EmpresaSocio {
  final String? idEmpresaSocio;
  final String? nomeEmpresaSocio;
  final String? cnpjEmpresaSocio;

  final List<Person>? membrosEmpresaSocio;
  final List<Telefone>? telefone;
  final List<Email>? email;
  final Status? status;

  EmpresaSocio({
    this.idEmpresaSocio,
    this.nomeEmpresaSocio,
    this.cnpjEmpresaSocio,
    this.membrosEmpresaSocio,
    this.telefone,
    this.email,
    this.status,
  });

  factory EmpresaSocio.fromJson(Map<String, dynamic> json) {
    return EmpresaSocio(
      idEmpresaSocio: json['id_empresa_socio'],
      nomeEmpresaSocio: json['nome_empresa_socio'],
      cnpjEmpresaSocio: json['cnpj_empresa_socio'],

      membrosEmpresaSocio: (json['membros_empresa_socio'] as List?)
          ?.map((e) => Person.fromJson(e))
          .toList(),

      telefone: (json['telefone'] as List?)
          ?.map((e) => Telefone.fromJson(e))
          .toList(),

      email: (json['email'] as List?)
          ?.map((e) => Email.fromJson(e))
          .toList(),

      status:
      json['status'] != null ? Status.fromJson(json['status']) : null,
    );
  }
}

// =====================================================
// PERSON
// =====================================================

class Person {
  final String? id;
  final String? name;
  final String? age;

  Person({this.id, this.name, this.age});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      age: json['age'],
    );
  }
}