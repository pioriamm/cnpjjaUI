class EmpresasConciliadora {
  Id? iId;
  String? cnpj;
  String? razaoSocial;
  String? alias;
  String? cna;
  String? cnaDescricao;
  bool? pesquisado;
  bool? conciliadora;

  EmpresasConciliadora(
      {this.iId,
        this.cnpj,
        this.razaoSocial,
        this.alias,
        this.cna,
        this.cnaDescricao,
        this.pesquisado,
        this.conciliadora});

  EmpresasConciliadora.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
    cnpj = json['cnpj'];
    razaoSocial = json['razaoSocial'];
    alias = json['alias'];
    cna = json['cna'];
    cnaDescricao = json['cnaDescricao'];
    pesquisado = json['pesquisado'];
    conciliadora = json['conciliadora'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iId != null) {
      data['_id'] = this.iId!.toJson();
    }
    data['cnpj'] = this.cnpj;
    data['razaoSocial'] = this.razaoSocial;
    data['alias'] = this.alias;
    data['cna'] = this.cna;
    data['cnaDescricao'] = this.cnaDescricao;
    data['pesquisado'] = this.pesquisado;
    data['conciliadora'] = this.conciliadora;
    return data;
  }
}

class Id {
  String? oid;

  Id({this.oid});

  Id.fromJson(Map<String, dynamic> json) {
    oid = json['$oid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$oid'] = this.oid;
    return data;
  }
}
