
import 'package:proj_flutter/model/Dados.dart';

class Prospectar {
  final String? id;
  final List<Dados>? dados;

  Prospectar({this.id, this.dados});

  factory Prospectar.fromJson(Map<String, dynamic> json) {
    return Prospectar(id: json['id'], dados: (json['dados'] as List?)?.map((e) => Dados.fromJson(e)).toList());
  }
}
