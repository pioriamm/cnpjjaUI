import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/view/widgets/titulo_contador.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:cnpjjaUi/model/enum_menu_item.dart';
import 'package:cnpjjaUi/view/widgets/empresa_card_simples_cnpja_widget.dart';
import 'package:cnpjjaUi/view/widgets/filtro_busca_widget.dart';
import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';

import '../../helprs/cores.dart';
import '../../model/enum_filtro_cliente.dart';
import '../../modelview/buscar_base_cnpja_provider.dart';

class TelaEmpresasSocio extends StatefulWidget {
  const TelaEmpresasSocio({super.key});

  @override
  State<TelaEmpresasSocio> createState() => _TelaEmpresasSocioState();
}

class _TelaEmpresasSocioState extends State<TelaEmpresasSocio> {
  final TextEditingController _filtroController = TextEditingController();

  MenuItem _selected = MenuItem.empresaSocio;
  FiltroCliente _filtroCliente = FiltroCliente.todos;

  String filtroTexto = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BuscarBaseCnpjaProvider>().buscarDadosCnpja();
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

    return SelectionArea(
      child: Scaffold(
        body: Row(
          children: [
            /// SIDEBAR
            SizedBox(
              width: tela.width * 0.2,
              child: SideBarWidget(
                selectedItem: _selected,
                onItemSelected: (item) => setState(() => _selected = item),
              ),
            ),

            /// CONTEÚDO
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: tela.width * 0.09, vertical: 50),
                child: Consumer<BuscarBaseCnpjaProvider>(
                  builder: (_, provider, __) {
                    final filtro = filtroTexto.toLowerCase();
                    final cnpjsUnicos = <String>{};

                    final empresasSociosFiltradas =
                    provider.listaProspecao
                        .expand((p) => p.dados?.isNotEmpty == true
                        ? p.dados!.first.membros
                        ?.expand((m) => m.empresas ?? []) ??
                        []
                        : [])
                        .where((e) {
                      final cnpj = e.cnpjEmpresaSocio;

                      if (cnpj == null ||
                          cnpj.isEmpty ||
                          !cnpjsUnicos.add(cnpj)) {
                        return false;
                      }

                      final matchTexto =
                          (e.nomeEmpresaSocio ?? '')
                              .toLowerCase()
                              .contains(filtro) ||
                              cnpj.contains(filtro);

                      final ehCliente =
                          e.eConciliadora ?? false;

                      bool matchCliente;

                      switch (_filtroCliente) {
                        case FiltroCliente.cliente:
                          matchCliente = ehCliente;
                          break;
                        case FiltroCliente.naoCliente:
                          matchCliente = !ehCliente;
                          break;
                        case FiltroCliente.todos:
                          matchCliente = true;
                          break;
                      }

                      return matchTexto && matchCliente;
                    })
                        .toList();

                    final totalParceiros =
                        empresasSociosFiltradas.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Empresas Sócios",
                          style: TextStyle(
                            fontSize: 30,
                            color: Cores.verde_escuro,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TituloContador(
                          lista: totalParceiros,
                          titulo: 'empresas cadastradas.',
                        ),
                        const SizedBox(height: 15),

                        /// BUSCA + FILTRO
                        Row(
                          children: [
                            Expanded(
                              child: FiltroBuscaWidget(
                                controller: _filtroController,
                                hintText:
                                'Filtrar por CNPJ ou Nome',
                                onChanged: (v) {
                                  setState(() {
                                    filtroTexto = v;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              height: 50,
                              padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius:
                                BorderRadius.circular(14),
                                border: Border.all(
                                    color: Colors.grey.shade300),
                              ),
                              child: DropdownButtonHideUnderline(
                                child:
                                DropdownButton<FiltroCliente>(
                                  value: _filtroCliente,
                                  icon: const Icon(
                                      Icons.keyboard_arrow_down),
                                  items: const [
                                    DropdownMenuItem(
                                        value:
                                        FiltroCliente.todos,
                                        child: Text('Todos')),
                                    DropdownMenuItem(
                                        value:
                                        FiltroCliente
                                            .cliente,
                                        child:
                                        Text('É cliente')),
                                    DropdownMenuItem(
                                        value:
                                        FiltroCliente
                                            .naoCliente,
                                        child: Text(
                                            'Não é cliente')),
                                  ],
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      _filtroCliente =
                                          value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        /// LISTA
                        Expanded(
                          child: Builder(
                            builder: (_) {
                              if (provider.isLoading) {
                                return const Center(
                                    child:
                                    CircularProgressIndicator());
                              }

                              if (provider.erro != null) {
                                return Center(
                                    child: Text(
                                        "Erro: ${provider.erro}"));
                              }

                              if (empresasSociosFiltradas
                                  .isEmpty) {
                                return const Center(
                                    child: Text(
                                        "Nenhuma empresa encontrada"));
                              }

                              return ListView.builder(
                                itemCount:
                                empresasSociosFiltradas
                                    .length,
                                itemBuilder:
                                    (context, index) {
                                  final empresaSocio =
                                  empresasSociosFiltradas[
                                  index];

                                  final prospectarPai =
                                  provider
                                      .listaProspecao
                                      .firstWhere(
                                        (p) {
                                      final dados =
                                      p.dados
                                          ?.isNotEmpty ==
                                          true
                                          ? p.dados!
                                          .first
                                          : null;

                                      if (dados ==
                                          null) {
                                        return false;
                                      }

                                      return dados
                                          .membros
                                          ?.expand((m) =>
                                      m.empresas ??
                                          [])
                                          .any((e) =>
                                      e.cnpjEmpresaSocio ==
                                          empresaSocio
                                              .cnpjEmpresaSocio) ??
                                          false;
                                    },
                                    orElse: () =>
                                    provider
                                        .listaProspecao
                                        .first,
                                  );

                                  return GestureDetector(
                                    onTap: () =>
                                        context.push(
                                          '/empresa-resumo',
                                          extra:
                                          prospectarPai,
                                        ),
                                    child:
                                    EmpresaCardSimplesCnpjaWidget(
                                      empresa:
                                      empresaSocio,
                                      empresaPai:
                                      prospectarPai
                                          .dados
                                          ?.first
                                          .empresaRaiz ??
                                          "",
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}