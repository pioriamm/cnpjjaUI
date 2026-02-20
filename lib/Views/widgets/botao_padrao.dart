import 'package:flutter/material.dart';

class BotaoPadrao extends StatelessWidget {
  final VoidCallback acao;
  final Color cor;
  final List<Widget> conteudo;

  BotaoPadrao({super.key, required this.acao, required this.cor, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: acao,
      child: Container(

        height: 50,
        width: 170,
        decoration: BoxDecoration(color: cor,borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: conteudo),
        ),
      ),
    );
  }
}
