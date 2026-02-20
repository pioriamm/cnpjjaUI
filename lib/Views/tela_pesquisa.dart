import 'package:flutter/material.dart';
import 'package:proj_flutter/Views/widgets/ClienteCardWidget.dart';
import 'package:proj_flutter/Views/widgets/FiltroBuscaWidget.dart';
import 'package:proj_flutter/Views/widgets/IndicadorCardWidget.dart';
import 'package:proj_flutter/Views/widgets/dialogs/NovoSocioDialog.dart';
import 'package:proj_flutter/Views/widgets/SideBarWidget.dart';
import 'package:proj_flutter/Views/widgets/botao_padrao.dart';

import '../Models/enum_MenuItem.dart';
import '../Models/novoLayout/Socios.dart';
import '../helprs/Cores.dart';

class TelaPesquisa extends StatefulWidget {
  TelaPesquisa({super.key});

  @override
  State<TelaPesquisa> createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  final List<Socio> listaSocios = [];

  MenuItem _selected = MenuItem.socios;

  final TextEditingController _filtroController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var tela = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(
        children: [
          /// SIDEBAR
          Container(
            width: tela.width * 0.2,
            height: double.infinity,
            child: SideBarWidget(
              selectedItem: _selected,
              onItemSelected: (item) {
                setState(() {
                  _selected = item;
                });
              },
            ),
          ),

          /// CONTEÚDO PRINCIPAL
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: (tela.width * 0.09), vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Container(
                    decoration: BoxDecoration(
                        color: Cores.verde_escuro,
                        borderRadius: BorderRadius.circular(10),),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Pesquisa de Sócios e Empresas",
                            style: TextStyle(fontSize: 30, color: Cores.branco, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Busque por nome do sócio, CPF ou CNPJ para encontrar empresas vinculadas. ",
                            style: TextStyle(fontSize: 15, color: Cores.cinza),
                          ),
                          SizedBox(height: 35),
                          Row(
                            children: [
                              Expanded(
                                child: FiltroBuscaWidget(
                                  controller: _filtroController,
                                  hintText: 'Nome do sócio, CPF (000.000.000-00) ou CNPJ...',
                                ),
                              ),
                              SizedBox(width: 20),
                              BotaoPadrao(
                                acao: () async {
                                  final resultado = await showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const NovoSocioDialog(),
                                  );

                                  if (resultado != null) {
                                    print(resultado);
                                  }
                                },
                                cor: Cores.verde_claro,
                                conteudo: [Text("Pesquisar", style: TextStyle(color: Cores.branco, fontSize: 16))],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      IndicadorCardWidget(
                        icon: Icons.group,
                        valor: 3,
                        titulo: "Sócios cadastrados",
                      ),
                      IndicadorCardWidget(
                        icon: Icons.apartment,
                        valor: 3,
                        titulo: "Empresas cadastradas",
                      ),
                      IndicadorCardWidget(
                        icon: Icons.trending_up,
                        valor: 5,
                        titulo: "vinculos registrados",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
