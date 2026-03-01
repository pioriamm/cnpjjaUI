import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:flutter/material.dart';

class TituloContador extends StatelessWidget {
  final int lista;
  final String titulo;

  const TituloContador({
    super.key,
    required this.lista, required this.titulo,
  });



  @override
  Widget build(BuildContext context) {
    return Text("${Formatadores.formatarNumeroMilhas(lista)} ${titulo}", style: const TextStyle(fontSize: 15));
  }
}