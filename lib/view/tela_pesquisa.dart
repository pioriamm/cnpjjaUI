import 'package:flutter/material.dart';
import 'package:proj_flutter/model/enum_MenuItem.dart';
import 'package:proj_flutter/model/prospec.dart';
import 'package:proj_flutter/modelview/buscarApiMongo.dart';
import 'package:proj_flutter/view/tela_empresas.dart';
import 'package:proj_flutter/view/tela_socio.dart';
import 'package:proj_flutter/view/widgets/FiltroBuscaWidget.dart';
import 'package:proj_flutter/view/widgets/IndicadorCardMonetaryWidget.dart';
import 'package:proj_flutter/view/widgets/IndicadorCardWidget.dart';
import 'package:proj_flutter/view/widgets/SideBarWidget.dart';
import 'package:proj_flutter/view/widgets/botao_padrao.dart';
import 'package:proj_flutter/view/widgets/dialogs/NovoSocioDialog.dart';
import '../helprs/Cores.dart';

class TelaPesquisa extends StatefulWidget {



  TelaPesquisa({super.key});

  @override
  State<TelaPesquisa> createState() => _TelaPesquisaState();
}

class _TelaPesquisaState extends State<TelaPesquisa> {
  List<Prospectar> empresas = [];
  List<Prospectar> empresasFiltradas = [];
  bool carregando = true;
  String? erro;
  MenuItem _selected = MenuItem.pesquisa;


  final TextEditingController _filtroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarEmpresas();
  }
  Future<void> _carregarEmpresas() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultado = await BuscarApiMongo.buscarDadosMongo();

      setState(() {
        empresas = resultado;
        empresasFiltradas = List.from(resultado);
      });
    } catch (e) {
      setState(() {
        erro = e.toString();
      });
    } finally {
      setState(() {
        carregando = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    var tela = MediaQuery.of(context).size;
    var ticketMedido = (empresasFiltradas.length * 150.55);

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
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.end,
                    children: [
                      IndicadorCardMonetaryWidget(
                        icon: Icons.sell_outlined,
                        valor: ticketMedido,
                        titulo: "Ticket Médio",
                      ),
                       IndicadorCardWidget(
                        icon: Icons.badge,
                        valor: empresas
                            .expand((e) => e.dados ?? [])
                            .expand((d) => d.membros ?? [])
                            .length,
                        titulo: "Sócios cadastrados", tela: TelaSocio(),
                      ),
                       IndicadorCardWidget(
                        icon: Icons.apartment,
                        valor: empresas.length,
                        titulo: "Empresas cadastradas", tela: TelaEmpresas(),
                      ),
                      const IndicadorCardWidget(
                        icon: Icons.trending_up,
                        valor: 5,
                        titulo: "Vínculos registrados", tela: TelaEmpresas(),
                      ),
                      const IndicadorCardWidget(
                        icon: Icons.ads_click,
                        valor: 5,
                        titulo: "Oportuniades Diretas", tela: TelaEmpresas(),
                      ),
                      const IndicadorCardWidget(
                        icon: Icons.account_tree,
                        valor: 5,
                        titulo: "Oportunidades Indiretas", tela: TelaEmpresas(),
                      ),

                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
