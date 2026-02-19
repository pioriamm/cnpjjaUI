import 'package:flutter/material.dart';
import 'package:proj_flutter/Views/tela_prospectar.dart';

import '../Models/baseConciliadora.dart';
import 'bt_menu.dart';
import 'tela_consultaCnpjPage.dart';

class TelaMenus extends StatelessWidget {
  const TelaMenus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            bt_menu(
              tela: TelaConsultaCnpjPage(
                cnpjs: BaseConciliadora.Lista_base_conciliadora,
              ),
              nomeBotao: 'Popular Base',
            ),
            bt_menu(
              tela: TelaProspectar(),
              nomeBotao: 'Prospectar Clientes',
            ),
          ],
        ),
      ),
    );
  }
}
