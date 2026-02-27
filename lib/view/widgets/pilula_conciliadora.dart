import 'package:cnpjjaUi/helprs/Cores.dart';
import 'package:flutter/material.dart';

class PilulaConciliadora extends StatelessWidget {
  const PilulaConciliadora({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Cores.verde_claro_W40, borderRadius: BorderRadius.circular(20)),
      child: Image.asset('assets/img/conciliadora_icon.jpeg', width: 70, height: 35, fit: BoxFit.cover),
    );
  }
}
