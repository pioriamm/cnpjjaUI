class Cnae {
  final int? id;
  final String? descricao;

  Cnae({this.id, this.descricao});

  factory Cnae.fromJson(Map<String, dynamic> json) {
    return Cnae(id: json['id'], descricao: json['text']);
  }
}
