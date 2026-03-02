import 'package:cnpjjaUi/view/widgets/botao_padrao.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/helprs/cores.dart';

import 'package:cnpjjaUi/model/membo.dart';
import 'package:cnpjjaUi/model/enum_menu_item.dart';

import 'package:cnpjjaUi/view/widgets/titulo_contador.dart';
import 'package:cnpjjaUi/view/widgets/empresa_card_widget.dart';
import 'package:cnpjjaUi/view/widgets/filtro_busca_widget.dart';
import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';

import '../../modelview/buscar_base_cnpja_provider.dart';

class TelaEmpresas extends StatefulWidget {
  const TelaEmpresas({super.key});

  @override
  State<TelaEmpresas> createState() => _TelaEmpresasState();
}

class _TelaEmpresasState extends State<TelaEmpresas> {
  final TextEditingController _filtroController = TextEditingController();
  MenuItem _selected = MenuItem.empresas;
  String filtro = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BuscarBaseCnpjaProvider>().buscarDadosCnpja(reset: true);
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

                      return (dados.empresaRaiz ?? '')
                          .toLowerCase()
                          .contains(filtroLower) ||
                          (dados.alias ?? '')
                              .toLowerCase()
                              .contains(filtroLower) ||
                          (dados.cnpjRaizId ?? '')
                              .contains(filtro);
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
                          titulo: ' empresas carregadas.',
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: FiltroBuscaWidget(
                                controller: _filtroController,
                                hintText:
                                'Filtrar por razão social, CNPJ...',
                                onChanged: (valor) {
                                  setState(() {
                                    filtro = valor;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              height: 50,
                              child: provider.isLoading
                                  ? const SizedBox(
                                width: 40,
                                height: 40,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                                  : BotaoPadrao(
                                acao: provider.isLast
                                    ? null
                                    : () {
                                  provider.buscarDadosCnpja();
                                },
                                cor: Cores.verde_claro,
                                conteudo: [
                                  const Icon(Icons.add, color: Colors.white, size: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        /// LOADING INICIAL
                        if (provider.isLoading && lista.isEmpty)
                          const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )

                        /// ERRO
                        else if (provider.erro != null)
                          Expanded(
                            child: Center(
                              child: Text("Erro: ${provider.erro}"),
                            ),
                          )

                        /// VAZIO
                        else if (empresasFiltradas.isEmpty)
                            const Expanded(
                              child: Center(
                                child: Text("Nenhuma empresa encontrada"),
                              ),
                            )

                          /// LISTA
                          else
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                empresasFiltradas.length + (provider.isLast ? 0 : 1),
                                itemBuilder: (context, index) {

                                  if (index < empresasFiltradas.length) {

                                    final wrapper = empresasFiltradas[index];

                                    if (wrapper.dados == null || wrapper.dados!.isEmpty) {
                                      return const SizedBox();
                                    }

                                    final empresaAtual = wrapper.dados!.first;

                                    return EmpresaCardWidget(
                                      razaoSocial: empresaAtual.empresaRaiz ?? '',
                                      nomeFantasia: empresaAtual.alias ?? '',
                                      cnpj: Formatadores.formatarCnpj(
                                          empresaAtual.cnpjRaizId ?? ''),
                                      cnae: Formatadores.formatarCnae(
                                          "${empresaAtual.cnae?.id ?? ''}"),
                                      atividade: empresaAtual.cnae?.descricao ?? '',
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
                                  }
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