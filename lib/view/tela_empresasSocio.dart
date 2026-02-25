import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proj_flutter/model/enum_MenuItem.dart';
import 'package:proj_flutter/modelview/buscarApiMongo.dart';
import 'package:proj_flutter/view/widgets/EmpresaCardSimplesCnpjaWidget.dart';
import 'package:proj_flutter/view/widgets/FiltroBuscaWidget.dart';
import 'package:proj_flutter/view/widgets/SideBarWidget.dart';

import '../helprs/Cores.dart';
import '../model/EmpresasConciliadora.dart';
import '../model/prospec.dart';

class TelaEmpresasSocio extends StatefulWidget {
  const TelaEmpresasSocio({super.key});

  @override
  State<TelaEmpresasSocio> createState() => _TelaEmpresasSocioState();
}

class _TelaEmpresasSocioState extends State<TelaEmpresasSocio> {
  List<Prospectar> empresas = [];
  List<Prospectar> empresasFiltradas = [];
  List<EmpresasConciliadora> listaEmpresasConciliadora = [];

  bool carregando = true;
  String? erro;

  final TextEditingController _filtroController = TextEditingController();
  MenuItem _selected = MenuItem.empresaSocio;

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

  /// =====================================================
  /// CARREGAR EMPRESAS
  /// =====================================================
  Future<void> _carregarEmpresas() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultado = await BuscarApiMongo.buscarEmpresasBaseCnpjja();
      final listaConciliadora =
      await BuscarApiMongo.buscarBaseConciliadora();

      resultado.sort(
            (a, b) => _razaoSocial(a)
            .toLowerCase()
            .compareTo(_razaoSocial(b).toLowerCase()),
      );

      setState(() {
        empresas = resultado;
        empresasFiltradas = List.from(resultado);
        listaEmpresasConciliadora = listaConciliadora;
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

  /// =====================================================
  /// RAZÃO SOCIAL
  /// =====================================================
  String _razaoSocial(Prospectar p) {
    final dados = p.dados?.isNotEmpty == true ? p.dados!.first : null;
    return dados?.empresaRaiz ?? '';
  }

  /// =====================================================
  /// EMPRESAS DOS SÓCIOS (SEM DUPLICAR)
  /// =====================================================
  List<dynamic> _empresasOrdenadasDosSocios(Prospectar prospectar) {
    final dados = prospectar.dados?.isNotEmpty == true
        ? prospectar.dados!.first
        : null;

    if (dados == null) return [];

    final todasEmpresas =
        dados.membros?.expand((m) => m.empresas ?? []).toList() ?? [];

    final mapaUnico = {
      for (var e in todasEmpresas)
        if (e.cnpjEmpresaSocio != null) e.cnpjEmpresaSocio!: e,
    };

    final listaFinal = mapaUnico.values.toList();

    listaFinal.sort(
          (a, b) => (a.nomeEmpresaSocio ?? '')
          .toLowerCase()
          .compareTo((b.nomeEmpresaSocio ?? '').toLowerCase()),
    );

    return listaFinal;
  }

  int _totalEmpresasParceiros() {
    return empresasFiltradas.fold<int>(0, (total, empresa) {
      return total + _empresasOrdenadasDosSocios(empresa).length;
    });
  }

  /// =====================================================
  /// FILTRO
  /// =====================================================
  void _filtrar(String valor) {
    final busca = valor.toLowerCase();

    setState(() {
      empresasFiltradas = empresas.where((empresa) {
        final dados =
        empresa.dados?.isNotEmpty == true ? empresa.dados!.first : null;

        return (dados?.empresaRaiz ?? '')
            .toLowerCase()
            .contains(busca) ||
            (dados?.alias ?? '').toLowerCase().contains(busca) ||
            (dados?.cnpjRaizId ?? '').contains(busca);
      }).toList();
    });
  }

  /// =====================================================
  /// BUILD
  /// =====================================================
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
                  /// HEADER
                  Text(
                    "Empresas Sócios",
                    style: TextStyle(
                      fontSize: 30,
                      color: Cores.verde_escuro,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// TOTAL
                  Text(
                    "${_totalEmpresasParceiros()} "
                        "${_totalEmpresasParceiros() == 1 ? 'empresa cadastrada' : 'empresas cadastradas'}",
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 15),

                  /// FILTRO
                  FiltroBuscaWidget(
                    controller: _filtroController,
                    onChanged: _filtrar,
                    hintText: 'Filtrar por CNPJ ou Nome',
                  ),

                  const SizedBox(height: 15),

                  /// LISTA (LOADING APENAS AQUI)
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (erro != null) {
                          return Center(
                            child: Text("Erro: $erro"),
                          );
                        }

                        if (carregando) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (empresasFiltradas.isEmpty) {
                          return const Center(
                            child: Text("Nenhuma empresa encontrada"),
                          );
                        }

                        return ListView.builder(
                          itemCount: empresasFiltradas.length,
                          itemBuilder: (context, index) {
                            final empresa = empresasFiltradas[index];

                            final empresasSocios =
                            _empresasOrdenadasDosSocios(empresa);

                            return GestureDetector(
                              onTap: () {
                                context.push(
                                  '/empresa-resumo',
                                  extra: empresa,
                                );
                              },
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  ...empresasSocios.map((empresaSocio) {
                                    final empresaConvertida =
                                    EmpresasConciliadora(
                                      razaoSocial:
                                      empresaSocio.nomeEmpresaSocio,
                                      cnpj:
                                      empresaSocio.cnpjEmpresaSocio,
                                    );

                                    return EmpresaCardSimplesCnpjaWidget(
                                      empresa: empresaConvertida,
                                      listaEmpresasConciliadora:
                                      listaEmpresasConciliadora,
                                    );
                                  }),
                                ],
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
    );
  }
}