
import 'package:flutter/material.dart';
import 'Views/tela_prospectar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaProspectar(),
    );
  }
}






