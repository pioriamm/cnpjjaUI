class EmpresasConciliadora {
  String? id;
  String? cnpj;
  String? razaoSocial;
  String? alias;
  String? cna;
  String? cnaDescricao;
  bool? pesquisado;
  bool? conciliadora;

  EmpresasConciliadora(
      {this.id,
        this.cnpj,
        this.razaoSocial,
        this.alias,
        this.cna,
        this.cnaDescricao,
        this.pesquisado,
        this.conciliadora});

  EmpresasConciliadora.fromJson(Map<String, dynamic> json) {
    id = json['id'] ;
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
    data['id'] = this.id;
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

