class Telefone {
  final String? area;
  final String? number;
  final String? type;

  Telefone({this.area, this.number, this.type});

  factory Telefone.fromJson(Map<String, dynamic> json) {
    return Telefone(area: json['area'], number: json['number'], type: json['type']);
  }
}