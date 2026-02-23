class EmpresasConciliadora {
  String? alias;
  String? cnpj;
  String? id;
  bool? pesquisado;
  String? razaoSocial;

  EmpresasConciliadora(
      {this.alias, this.cnpj, this.id, this.pesquisado, this.razaoSocial});

  EmpresasConciliadora.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    cnpj = json['cnpj'];
    id = json['id'];
    pesquisado = json['pesquisado'];
    razaoSocial = json['razaoSocial'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alias'] = this.alias;
    data['cnpj'] = this.cnpj;
    data['id'] = this.id;
    data['pesquisado'] = this.pesquisado;
    data['razaoSocial'] = this.razaoSocial;
    return data;
  }
}
