class StatusEmpresa {
  final int? id;
  final String? text;

  StatusEmpresa({this.id, this.text});

  factory StatusEmpresa.fromJson(Map<String, dynamic> json) {
    return StatusEmpresa(id: json['id'], text: json['text']);
  }

  @override
  String toString() => text ?? '';
}