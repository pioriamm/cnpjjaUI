import 'package:cnpjjaUi/modelview/buscar_base_cnpja_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cnpjjaUi/model/membo.dart';
import 'package:cnpjjaUi/model/enum_menu_item.dart';
import 'package:cnpjjaUi/view/widgets/cliente_card_widget.dart';
import 'package:cnpjjaUi/view/widgets/filtro_busca_widget.dart';
import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';
import 'package:cnpjjaUi/view/widgets/botao_padrao.dart';
import 'package:cnpjjaUi/view/widgets/novo_socio_dialog.dart';
import 'package:cnpjjaUi/helprs/cores.dart';


class TelaSocioCadastro extends StatefulWidget {
  const TelaSocioCadastro({super.key});

  @override
  State<TelaSocioCadastro> createState() => _TelaSocioCadastroState();
}

class _TelaSocioCadastroState extends State<TelaSocioCadastro> {
  MenuItem _selected = MenuItem.sociosCadastro;

  final TextEditingController _filtroController = TextEditingController();

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
                  /// ===============================
                  /// EXTRAIR TODOS OS SÓCIOS
                  /// ===============================
                  final todosSocios = provider.listaProspecao
                      .expand((p) => p.dados ?? [])
                      .expand((d) => d.membros ?? [])
                      .toList();

                  /// remover duplicados
                  final mapaUnico = <String, Membros>{};

                  for (final socio in todosSocios) {
                    final chave = socio.idMembro ?? socio.nomeMembro ?? '';

                    if (chave.isNotEmpty) {
                      mapaUnico[chave] = socio;
                    }
                  }

                  final sociosUnicos = mapaUnico.values.toList()
                    ..sort((a, b) => (a.nomeMembro ?? '').toLowerCase().compareTo((b.nomeMembro ?? '').toLowerCase()));

                  /// ===============================
                  /// FILTRO
                  /// ===============================
                  final sociosFiltrados = sociosUnicos.where((socio) {
                    final nome = socio.nomeMembro?.toLowerCase() ?? '';

                    return nome.contains(filtroTexto);
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        children: [
                          Text(
                            "Sócios",
                            style: TextStyle(fontSize: 30, color: Cores.verde_escuro, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          BotaoPadrao(
                            acao: () async {
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const NovoSocioDialog(),
                              );
                            },
                            cor: Cores.verde_escuro,
                            conteudo: [
                              Icon(Icons.add, color: Cores.branco),
                              const SizedBox(width: 8),
                              Text("Novo Sócio", style: TextStyle(color: Cores.branco, fontSize: 16)),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text("${sociosFiltrados.length} sócios cadastrados", style: const TextStyle(fontSize: 15)),

                      const SizedBox(height: 15),

                      /// FILTRO
                      FiltroBuscaWidget(
                        controller: _filtroController,
                        hintText: 'Filtrar por nome...',
                        onChanged: (v) {
                          setState(() {
                            filtroTexto = v.toLowerCase();
                          });
                        },
                      ),

                      const SizedBox(height: 15),

                      /// LISTA
                      Expanded(
                        child: Builder(
                          builder: (_) {
                            if (provider.isLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (provider?.erro != null) {
                              return Center(child: Text("Erro: ${provider.erro}"));
                            }

                            if (sociosFiltrados.isEmpty) {
                              return const Center(child: Text("Nenhum sócio encontrado"));
                            }

                            return ListView.builder(
                              itemCount: sociosFiltrados.length,
                              itemBuilder: (context, index) {
                                final socio = sociosFiltrados[index];

                                return ClienteCardWidget(
                                  nome: socio.nomeMembro ?? '',
                                  cpf: socio.idMembro ?? "",
                                  telefone: '',
                                  email: '',
                                  quantidadeEmpresas: socio.empresas?.length ?? 0,
                                  onEdit: () {},
                                  onDelete: () {},
                                  empresas: socio.empresas ?? [],
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
    );
  }
}
