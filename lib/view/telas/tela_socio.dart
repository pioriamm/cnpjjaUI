import 'package:cnpjjaUi/view/widgets/titulo_contador.dart';
import 'package:flutter/material.dart';

import 'package:cnpjjaUi/helprs/cores.dart';
import 'package:cnpjjaUi/view/widgets/cliente_card_widget.dart';
import 'package:cnpjjaUi/view/widgets/filtro_busca_widget.dart';
import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';

import '../../model/dados.dart';
import '../../model/membo.dart';
import '../../model/enum_menu_item.dart';
import '../../model/prospec.dart';
import '../../repositorio/api_service.dart';

class TelaSocio extends StatefulWidget {
  const TelaSocio({super.key});

  @override
  State<TelaSocio> createState() => _TelaSocioState();
}

class _TelaSocioState extends State<TelaSocio> {
  MenuItem _selected = MenuItem.socios;

  List<Prospectar> empresas = [];
  List<Membros> socios = [];
  List<Membros> sociosFiltrados = [];

  bool carregando = true;
  String? erro;

  final TextEditingController _filtroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarEmpresas();
  }

  @override
  void dispose() {
    _filtroController.dispose();
    super.dispose();
  }

  /// ===============================
  /// CARREGA E FLATTEN DOS SÓCIOS
  /// ===============================
  Future<void> _carregarEmpresas() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultado = await ApiService.buscarEmpresasBaseCnpjja();

      final List<Membros> todosSocios = resultado
          .expand<Dados>((p) => p.dados ?? <Dados>[])
          .expand<Membros>((d) => d.membros ?? <Membros>[])
          .toList();

      /// remove duplicados
      final sociosUnicosMap = <String, Membros>{};

      for (final socio in todosSocios) {
        final chave = socio.idMembro ?? socio.nomeMembro ?? '';
        if (chave.isNotEmpty) {
          sociosUnicosMap[chave] = socio;
        }
      }

      final sociosUnicos = sociosUnicosMap.values.toList();

      sociosUnicos.sort(
            (a, b) => (a.nomeMembro ?? '')
            .toLowerCase()
            .compareTo((b.nomeMembro ?? '').toLowerCase()),
      );

      setState(() {
        empresas = resultado;
        socios = sociosUnicos;
        sociosFiltrados = List.from(sociosUnicos);
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

  /// ===============================
  /// FILTRO
  /// ===============================
  void _filtrar(String valor) {
    final texto = valor.toLowerCase();

    setState(() {
      sociosFiltrados = socios.where((socio) {
        final nome = socio.nomeMembro?.toLowerCase() ?? '';
        return nome.contains(texto);
      }).toList();
    });
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
                    /// HEADER
                    Row(
                      children: [
                        Text(
                          "Sócios",
                          style: TextStyle(
                            fontSize: 30,
                            color: Cores.verde_escuro,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),

                    const SizedBox(height: 8),
                    TituloContador(lista: sociosFiltrados.length, titulo: ' sócios cadastrados',),

                    const SizedBox(height: 15),

                    /// FILTRO
                    FiltroBuscaWidget(
                      controller: _filtroController,
                      onChanged: _filtrar,
                      hintText: 'Filtrar por nome...',
                    ),

                    const SizedBox(height: 15),

                    /// LISTA (ESTADOS CONTROLADOS AQUI)
                    Expanded(
                      child: Builder(
                        builder: (_) {
                          /// ERRO
                          if (erro != null) {
                            return Center(
                              child: Text("Erro: $erro"),
                            );
                          }

                          /// LOADING
                          if (carregando) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          /// VAZIO
                          if (sociosFiltrados.isEmpty) {
                            return const Center(
                              child: Text("Nenhum sócio encontrado"),
                            );
                          }

                          /// LISTA NORMAL
                          return ListView.builder(
                            itemCount: sociosFiltrados.length,
                            itemBuilder: (context, index) {
                              final socio = sociosFiltrados[index];

                              return ClienteCardWidget(
                                nome: socio.nomeMembro ?? '',
                                cpf: socio.idMembro ?? "",
                                telefone: '',
                                email: '',
                                quantidadeEmpresas:
                                socio.empresas?.length ?? 0,
                                onEdit: () {
                                  print("Editar ${socio.nomeMembro}");
                                },
                                onDelete: () {
                                  print("Excluir ${socio.nomeMembro}");
                                },
                                empresas: socio.empresas ?? [],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}