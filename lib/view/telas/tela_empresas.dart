import 'package:cnpjjaUi/helprs/cores.dart';
import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/model/enum_menu_item.dart';
import 'package:cnpjjaUi/view/widgets/botao_padrao.dart';
import 'package:cnpjjaUi/view/widgets/empresa_card_widget.dart';
import 'package:cnpjjaUi/view/widgets/filtro_busca_widget.dart';
import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';
import 'package:cnpjjaUi/view/widgets/titulo_contador.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modelview/buscar_base_cnpja_provider.dart';

class TelaEmpresas extends StatefulWidget {
  const TelaEmpresas({super.key});

  @override
  State<TelaEmpresas> createState() => _TelaEmpresasState();
}

class _TelaEmpresasState extends State<TelaEmpresas> {
  final TextEditingController _filtroController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  MenuItem _selected = MenuItem.empresas;
  String filtro = '';
  bool? filtroAtivo; // null = todos

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<BuscarBaseCnpjaProvider>().buscarDadosCnpja(reset: true);
    });

    _scrollController.addListener(() {
      final provider = context.read<BuscarBaseCnpjaProvider>();

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!provider.isLoading && !provider.isLast) {
          provider.buscarDadosCnpja();
        }
      }
    });
  }

  @override
  void dispose() {
    _filtroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tela = MediaQuery.of(context).size;

    return SelectionArea(
      child: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: tela.width * 0.2,
              child: SideBarWidget(
                selectedItem: _selected,
                onItemSelected: (item) => setState(() => _selected = item),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: tela.width * 0.09,
                  vertical: 50,
                ),
                child: Consumer<BuscarBaseCnpjaProvider>(
                  builder: (_, provider, __) {
                    final lista = provider.listaProspecao;

                    final empresasFiltradas = lista.where((empresa) {
                      if (empresa.dados == null || empresa.dados!.isEmpty) {
                        return false;
                      }

                      final dados = empresa.dados!.first;

                      final filtroLower = filtro.toLowerCase();

                      final ativo = dados.ativoConciliadora ?? false;

                      final filtroTexto =
                          (dados.empresaRaiz ?? '')
                              .toLowerCase()
                              .contains(filtroLower) ||
                              (dados.alias ?? '')
                                  .toLowerCase()
                                  .contains(filtroLower) ||
                              (dados.cnpjRaizId ?? '').contains(filtro);

                      final filtroStatus =
                      filtroAtivo == null ? true : ativo == filtroAtivo;

                      return filtroTexto && filtroStatus;
                    }).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Empresas da Base Conciliadora",
                          style: TextStyle(
                            fontSize: 30,
                            color: Cores.verde_escuro,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TituloContador(
                          lista: empresasFiltradas.length,
                          titulo: empresasFiltradas.length <2 ? ' empresa carregada.' : ' empresas carregadas.',
                        ),
                        const SizedBox(height: 15),

                        Row(
                          children: [
                            Expanded(
                              child: FiltroBuscaWidget(
                                controller: _filtroController,
                                hintText: 'Filtrar por razão social, CNPJ...',
                                onChanged: (valor) {
                                  setState(() {
                                    filtro = valor;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(width: 12),

                            Container(
                              height: 46,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xffE9E9E9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<bool?>(
                                  value: filtroAtivo,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  borderRadius: BorderRadius.circular(12),
                                  hint: const Text(
                                    "Status",
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: null,
                                      child: Text("Todos"),
                                    ),
                                    DropdownMenuItem(
                                      value: true,
                                      child: Text("Ativo"),
                                    ),
                                    DropdownMenuItem(
                                      value: false,
                                      child: Text("Inativo"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      filtroAtivo = value;
                                    });
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                          ],
                        ),

                        const SizedBox(height: 15),

                        if (provider.isLoading && lista.isEmpty)
                          const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (provider.erro != null)
                          Expanded(
                            child: Center(
                              child: Text("Erro: ${provider.erro}"),
                            ),
                          )
                        else if (empresasFiltradas.isEmpty)
                            const Expanded(
                              child: Center(
                                child: Text("Nenhuma empresa encontrada"),
                              ),
                            )
                          else
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: empresasFiltradas.length,
                                itemBuilder: (context, index) {
                                  final wrapper = empresasFiltradas[index];

                                  if (wrapper.dados == null ||
                                      wrapper.dados!.isEmpty) {
                                    return const SizedBox();
                                  }

                                  final empresaAtual = wrapper.dados!.first;

                                  return EmpresaCardWidget(
                                    ativoConciliadora:
                                    empresaAtual.ativoConciliadora ?? false,
                                    razaoSocial: empresaAtual.empresaRaiz ?? '',
                                    nomeFantasia: empresaAtual.alias ?? '',
                                    cnpj: Formatadores.formatarCnpj(
                                      empresaAtual.cnpjRaizId ?? '',
                                    ),
                                    cnae: Formatadores.formatarCnae(
                                      "${empresaAtual.cnae?.id ?? ''}",
                                    ),
                                    atividade:
                                    empresaAtual.cnae?.descricao ?? '',
                                    telefone: (empresaAtual.telefone ?? [])
                                        .map<String>((tel) =>
                                    "(${tel.area ?? ''}) ${tel.number ?? ''}")
                                        .join(' • '),
                                    email: (empresaAtual.email ?? []).isNotEmpty
                                        ? empresaAtual.email!.first.address ?? ''
                                        : 'Sem informações',
                                    socios: (empresaAtual.membros ?? [])
                                        .map((m) => m.nomeMembro ?? '')
                                        .toList(),
                                    empresasVinculadas:
                                    empresaAtual.membros ?? [],
                                    conciliadora:
                                    empresaAtual.eConciliadora ?? false,
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