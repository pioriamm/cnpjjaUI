import 'package:flutter/material.dart';

class bt_menu extends StatelessWidget {
  final Widget tela;
  final String nomeBotao;

  const bt_menu({super.key, required this.tela, required this.nomeBotao});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => tela),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 100,
          width: 150,
          child: Center(child: Text(nomeBotao)),
        ),
      ),
    );
  }
}
