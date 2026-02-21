class Socio {
  String? nomeCompleto;
  String? cpf;
  String? email;
  String? telefone;

  Socio({this.nomeCompleto, this.cpf, this.email, this.telefone});

  Socio.fromJson(Map<String, dynamic> json) {
    nomeCompleto = json['nome_completo'];
    cpf = json['cpf'];
    email = json['email'];
    telefone = json['telefone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome_completo'] = this.nomeCompleto;
    data['cpf'] = this.cpf;
    data['email'] = this.email;
    data['telefone'] = this.telefone;
    return data;
  }
}
