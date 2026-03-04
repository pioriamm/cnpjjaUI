import 'package:cnpjjaUi/helprs/cores.dart';
import 'package:cnpjjaUi/view/widgets/cliente_card_widget.dart';
import 'package:cnpjjaUi/view/widgets/filtro_busca_widget.dart';
import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';
import 'package:cnpjjaUi/view/widgets/titulo_contador.dart';
import 'package:flutter/material.dart';

import '../../model/dados.dart';
import '../../model/enum_menu_item.dart';
import '../../model/membo.dart';
import '../../repositorio/api_service.dart';

class TelaSocio extends StatefulWidget {
  const TelaSocio({super.key});

  @override
  State<TelaSocio> createState() => _TelaSocioState();
}

class _TelaSocioState extends State<TelaSocio> {
  MenuItem _selected = MenuItem.socios;

  List<Membros> socios = [];
  List<Membros> sociosFiltrados = [];

  bool carregando = false;
  bool isLast = false;

  int currentPage = 0;
  final int pageSize = 50;

  String? erro;

  final TextEditingController _filtroController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarPagina(reset: true);
  }

  @override
  void dispose() {
    _filtroController.dispose();
    super.dispose();
  }

  /// ===============================
  /// CARREGAR PAGINA
  /// ===============================
  Future<void> _carregarPagina({bool reset = false}) async {
    if (carregando) return;
    if (isLast && !reset) return;

    if (reset) {
      currentPage = 0;
      isLast = false;
      socios.clear();
      sociosFiltrados.clear();
    }

    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final pageResponse = await ApiService.buscarEmpresasBaseCnpjja(
        page: currentPage,
        size: pageSize,
      );

      final novosSocios = pageResponse.content
          .expand<Dados>((p) => p.dados ?? [])
          .expand<Membros>((d) => d.membros ?? [])
          .toList();

      /// Remove duplicados
      final mapa = <String, Membros>{
        for (var s in socios) (s.idMembro ?? s.nomeMembro ?? ''): s,
      };

      for (final socio in novosSocios) {
        final chave = socio.idMembro ?? socio.nomeMembro ?? '';
        if (chave.isNotEmpty) {
          mapa[chave] = socio;
        }
      }

      socios = mapa.values.toList();

      socios.sort(
        (a, b) => (a.nomeMembro ?? '').toLowerCase().compareTo(
          (b.nomeMembro ?? '').toLowerCase(),
        ),
      );

      sociosFiltrados = List.from(socios);

      isLast = pageResponse.last;
      currentPage++;
    } catch (e) {
      erro = e.toString();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sócios",
                      style: TextStyle(
                        fontSize: 30,
                        color: Cores.verde_escuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TituloContador(
                      lista: sociosFiltrados.length,
                      titulo: ' sócios carregados',
                    ),

                    const SizedBox(height: 15),

                    FiltroBuscaWidget(
                      controller: _filtroController,
                      onChanged: _filtrar,
                      hintText: 'Filtrar por nome...',
                    ),

                    const SizedBox(height: 15),

                    Expanded(
                      child: Builder(
                        builder: (_) {
                          if (erro != null) {
                            return Center(child: Text("Erro: $erro"));
                          }

                          if (carregando && socios.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (sociosFiltrados.isEmpty) {
                            return const Center(
                              child: Text("Nenhum sócio encontrado"),
                            );
                          }

                          return ListView.builder(
                            itemCount:
                                sociosFiltrados.length + (isLast ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index < sociosFiltrados.length) {
                                final socio = sociosFiltrados[index];

                                return ClienteCardWidget(
                                  nome: socio.nomeMembro ?? '',
                                  cpf: socio.idMembro ?? "",
                                  telefone: '',
                                  email: '',
                                  quantidadeEmpresas:
                                      socio.empresas?.length ?? 0,
                                  onEdit: () {},
                                  onDelete: () {},
                                  empresas: socio.empresas ?? [],
                                );
                              }

                              /// BOTÃO CARREGAR MAIS
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: carregando
                                        ? null
                                        : () => _carregarPagina(),
                                    child: carregando
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text("Carregar mais 50"),
                                  ),
                                ),
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
