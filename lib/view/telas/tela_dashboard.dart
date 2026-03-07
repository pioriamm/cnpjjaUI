import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/model/enum_menu_item.dart';
import 'package:cnpjjaUi/modelview/auditoria_provider.dart';
import 'package:cnpjjaUi/modelview/buscar_base_cnpja_provider.dart';
import 'package:cnpjjaUi/view/telas/tela_empresas.dart';
import 'package:cnpjjaUi/view/telas/tela_socio.dart';
import 'package:cnpjjaUi/view/widgets/botao_padrao.dart';
import 'package:cnpjjaUi/view/widgets/filtro_busca_widget.dart';
import 'package:cnpjjaUi/view/widgets/indicador_card_monetary_widget.dart';
import 'package:cnpjjaUi/view/widgets/indicador_card_shimmer_widget.dart';
import 'package:cnpjjaUi/view/widgets/indicador_card_widget.dart';
import 'package:cnpjjaUi/view/widgets/novo_socio_dialog.dart';
import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helprs/cores.dart';

class TelaDashBoard extends StatefulWidget {
  const TelaDashBoard({super.key});

  @override
  State<TelaDashBoard> createState() => _TelaDashBoardState();
}

class _TelaDashBoardState extends State<TelaDashBoard> {

  MenuItem _selected = MenuItem.pesquisa;
  final TextEditingController _filtroController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AuditoriaProvider>().buscarAuditoria();
    });
  }

  @override
  void dispose() {
    _filtroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tela = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(
        children: [
          /// SIDEBAR
          SizedBox(
            width: tela.width * 0.2,
            child: SideBarWidget(
              selectedItem: _selected,
              onItemSelected: (item) {
                setState(() => _selected = item);
              },
            ),
          ),

          /// CONTEÚDO
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: tela.width * 0.09,
                vertical: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),

                  /// CARDS
                  Consumer<AuditoriaProvider>(
                    builder: (context, provider, _) {

                      final isLoading = provider.loading;

                      return Wrap(
                        spacing: 30,
                        runSpacing: 30,
                        children: [
                          _buildAnimatedCard(
                            isLoading: isLoading,
                            child: IndicadorCardMonetaryWidget(
                              icon: Icons.sell_outlined,
                              valor: provider.ticketMedio,
                              titulo: "Ticket Médio",
                            ),
                          ),

                          _buildAnimatedCard(
                            isLoading: isLoading,
                            child: IndicadorCardWidget(
                              icon: Icons.badge,
                              valor: Formatadores.formatarNumeroMilhas(
                                provider.totalSocios,
                              ),
                              titulo: "Sócios cadastrados",
                              tela: const TelaSocio(),
                            ),
                          ),

                          _buildAnimatedCard(
                            isLoading: isLoading,
                            child: IndicadorCardWidget(
                              icon: Icons.apartment,
                              valor: Formatadores.formatarNumeroMilhas(
                                provider.totalEmpresas,
                              ),
                              titulo: "Empresas cadastradas",
                              tela: const TelaEmpresas(),
                            ),
                          ),

                          _buildAnimatedCard(
                            isLoading: isLoading,
                            child: IndicadorCardWidget(
                              icon: Icons.trending_up,
                              valor: Formatadores.formatarNumeroMilhas(
                                provider.totalEmpresas,
                              ),
                              titulo: "Vínculos registrados",
                              tela: const TelaEmpresas(),
                            ),
                          ),

                          _buildAnimatedCard(
                            isLoading: isLoading,
                            child: IndicadorCardWidget(
                              icon: Icons.ads_click,
                              valor: Formatadores.formatarNumeroMilhas(
                                provider.sociosDiretosUnicos,
                              ),
                              titulo: "Oportunidades Diretas",
                              tela: const TelaEmpresas(),
                            ),
                          ),

                          _buildAnimatedCard(
                            isLoading: isLoading,
                            child: IndicadorCardWidget(
                              icon: Icons.account_tree,
                              valor: Formatadores.formatarNumeroMilhas(
                                provider.sociosIndiretosUnicos,
                              ),
                              titulo: "Oportunidades Indiretas",
                              tela: const TelaEmpresas(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// HEADER
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Cores.verde_escuro,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pesquisa de Sócios e Empresas",
            style: TextStyle(
              fontSize: 30,
              color: Cores.branco,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Busque por nome do sócio, CPF ou CNPJ para encontrar empresas vinculadas.",
            style: TextStyle(
              fontSize: 15,
              color: Cores.cinza,
            ),
          ),
          const SizedBox(height: 35),
          Row(
            children: [
              Expanded(
                child: FiltroBuscaWidget(
                  controller: _filtroController,
                  hintText: 'Nome do sócio, CPF ou CNPJ...',
                ),
              ),
              const SizedBox(width: 20),
              BotaoPadrao(
                acao: () async {
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const NovoSocioDialog(),
                  );
                },
                cor: Cores.verde_claro,
                conteudo: [
                  Text(
                    "Pesquisar",
                    style: TextStyle(
                      color: Cores.branco,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard({
    required bool isLoading,
    required Widget child,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: isLoading
          ? const IndicadorCardShimmer(key: ValueKey('loading'))
          : Container(
        key: const ValueKey('content'),
        child: child,
      ),
    );
  }
}