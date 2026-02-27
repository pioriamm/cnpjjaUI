import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/model/enum_menu_item.dart';
import 'package:cnpjjaUi/model/prospec.dart';
import 'package:cnpjjaUi/view/widgets/empresa_card_widget.dart';
import 'package:cnpjjaUi/view/widgets/filtro_busca_widget.dart';
import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';

import '../../helprs/cores.dart';
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

    /// chama provider ao abrir tela
    Future.microtask(() {
      context.read<BuscarBaseCnpjaProvider>().buscarDadosCnpja(context: context);
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
            child: SideBarWidget(selectedItem: _selected, onItemSelected: (item) => setState(() => _selected = item)),
          ),

          /// CONTEÚDO
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tela.width * 0.09, vertical: 50),
              child: Consumer<BuscarBaseCnpjaProvider>(
                builder: (_, provider, __) {
                  /// filtra localmente
                  final empresasFiltradas = provider.listaProspecao.where((empresa) {
                    final dados = empresa.dados?.isNotEmpty == true ? empresa.dados!.first : null;

                    if (dados == null) return false;

                    return dados.empresaRaiz?.toLowerCase().contains(filtro.toLowerCase()) == true ||
                        dados.alias?.toLowerCase().contains(filtro.toLowerCase()) == true ||
                        dados.cnpjRaizId?.contains(filtro) == true;
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Text(
                        "Empresas",
                        style: TextStyle(fontSize: 30, color: Cores.verde_escuro, fontWeight: FontWeight.w700),
                      ),

                      const SizedBox(height: 8),

                      Text("${empresasFiltradas.length} empresas cadastradas", style: const TextStyle(fontSize: 15)),

                      const SizedBox(height: 15),

                      /// FILTRO
                      FiltroBuscaWidget(
                        controller: _filtroController,
                        hintText: 'Filtrar por razão social, nome fantasia ou CNPJ...',
                        onChanged: (valor) {
                          setState(() {
                            filtro = valor;
                          });
                        },
                      ),

                      const SizedBox(height: 15),

                      /// LOADING
                      if (provider.isLoading)
                        const Expanded(child: Center(child: CircularProgressIndicator()))
                      /// ERRO
                      else if (provider.erro != null)
                        Expanded(child: Center(child: Text("Erro: ${provider.erro}")))
                      /// VAZIO
                      else if (empresasFiltradas.isEmpty)
                        const Expanded(child: Center(child: Text("Nenhuma empresa encontrada")))
                      /// LISTA
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: empresasFiltradas.length,
                            itemBuilder: (context, index) {
                              final empresa = empresasFiltradas[index];
                              final empresaAtual = empresa.dados?.isNotEmpty == true ? empresa.dados!.first : null;

                              return EmpresaCardWidget(
                                razaoSocial: empresaAtual?.empresaRaiz ?? '',
                                nomeFantasia: empresaAtual?.alias ?? '',
                                cnpj: Formatadores.formatarCnpj("${empresaAtual?.cnpjRaizId}"),
                                cnae: Formatadores.formatarCnae("${empresaAtual?.cnae?.id ?? ''}") ?? '',
                                atividade: empresaAtual?.cnae?.descricao ?? '',
                                telefone:
                                    empresaAtual?.telefone
                                        ?.map((tel) => "(${tel.area ?? ''}) ${tel.number ?? ''}")
                                        .join(' • ') ??
                                    '',
                                email: empresaAtual?.email?.isNotEmpty == true
                                    ? empresaAtual!.email!.first.address ?? ''
                                    : 'Sem informações',
                                socios: empresaAtual?.membros?.map((m) => m.nomeMembro ?? '').toList() ?? [],
                                empresasVinculadas: empresaAtual?.membros ?? [],
                                conciliadora: empresaAtual!.eConciliadora!,
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
    );
  }
}
