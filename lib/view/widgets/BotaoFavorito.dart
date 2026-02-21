import 'package:flutter/material.dart';

class BotaoFavorito extends StatefulWidget {
  const BotaoFavorito({super.key});

  @override
  State<BotaoFavorito> createState() => _BotaoFavoritoState();
}

class _BotaoFavoritoState extends State<BotaoFavorito> {
  bool favorito = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        favorito ? Icons.star : Icons.star_border,
        color: favorito ? Colors.amber : Colors.grey,
        size: 28,
      ),
      onPressed: () {
        setState(() {
          favorito = !favorito;
        });
      },
    );
  }
}
