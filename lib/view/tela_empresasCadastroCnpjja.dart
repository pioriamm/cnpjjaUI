import 'package:flutter/material.dart';
import 'package:proj_flutter/model/enum_MenuItem.dart';
import 'package:proj_flutter/modelview/buscarApiMongo.dart';
import 'package:proj_flutter/view/tela_empresasResumo.dart';
import 'package:proj_flutter/view/widgets/EmpresaCardSimplesCnpjaWidget.dart';
import 'package:proj_flutter/view/widgets/FiltroBuscaWidget.dart';
import 'package:proj_flutter/view/widgets/SideBarWidget.dart';

import '../helprs/Cores.dart';
import '../model/EmpresasConciliadora.dart';
import '../model/prospec.dart';
import '../model/EmpresaSocio.dart';

class TelaEmpresasCadastroCnpjja extends StatefulWidget {
  const TelaEmpresasCadastroCnpjja({super.key});

  @override
  State<TelaEmpresasCadastroCnpjja> createState() =>
      _TelaEmpresasCadastroCnpjjaState();
}

class _TelaEmpresasCadastroCnpjjaState
    extends State<TelaEmpresasCadastroCnpjja> {
  List<Prospectar> empresas = [];
  List<Prospectar> empresasFiltradas = [];
  List<EmpresasConciliadora> listaEmpresasConciliadora = [];

  bool carregando = true;
  String? erro;

  final TextEditingController _filtroController = TextEditingController();

  MenuItem _selected = MenuItem.empresasCadastro;

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
      final resultado =
      await BuscarApiMongo.buscarEmpresasBaseCnpjja();

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
        carregando = false;
      });
    } catch (e) {
      setState(() {
        erro = e.toString();
        carregando = false;
      });
    }
  }

  int _totalEmpresasParceiros() {
    return empresasFiltradas.fold<int>(0, (total, empresa) {
      final empresasSocios = _empresasOrdenadasDosSocios(empresa);
      return total + empresasSocios.length;
    });
  }
  /// =====================================================
  /// RAZÃO SOCIAL SEGURA
  /// =====================================================
  String _razaoSocial(Prospectar p) {
    final dados =
    p.dados?.isNotEmpty == true ? p.dados!.first : null;
    return dados?.empresaRaiz ?? '';
  }

  /// =====================================================
  /// EMPRESAS DOS SÓCIOS
  /// (SEM DUPLICAR + ORDENADA)
  /// =====================================================
  List<dynamic> _empresasOrdenadasDosSocios(
      Prospectar prospectar) {
    final dados =
    prospectar.dados?.isNotEmpty == true
        ? prospectar.dados!.first
        : null;

    if (dados == null) return [];

    final todasEmpresas =
        dados.membros
            ?.expand((m) => m.empresas ?? [])
            .toList() ??
            [];

    /// remove duplicadas por CNPJ
    final mapaUnico = {
      for (var e in todasEmpresas)
        if (e.cnpjEmpresaSocio != null)
          e.cnpjEmpresaSocio!: e,
    };

    final listaFinal = mapaUnico.values.toList();

    listaFinal.sort(
          (a, b) => (a.nomeEmpresaSocio ?? '')
          .toLowerCase()
          .compareTo(
        (b.nomeEmpresaSocio ?? '').toLowerCase(),
      ),
    );

    return listaFinal;
  }

  /// =====================================================
  /// FILTRO
  /// =====================================================
  void _filtrar(String valor) {
    final busca = valor.toLowerCase();

    setState(() {
      empresasFiltradas = empresas.where((empresa) {
        final dados =
        empresa.dados?.isNotEmpty == true
            ? empresa.dados!.first
            : null;

        return (dados?.empresaRaiz ?? '')
            .toLowerCase()
            .contains(busca) ||
            (dados?.alias ?? '')
                .toLowerCase()
                .contains(busca) ||
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

    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (erro != null) {
      return Scaffold(
        body: Center(child: Text("Erro: $erro")),
      );
    }

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
                    "Lista de Empresas CNPJÁ",
                    style: TextStyle(
                      fontSize: 30,
                      color: Cores.verde_escuro,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// TOTAL GERAL
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

                  /// LISTA
                  Expanded(
                    child: ListView.builder(
                      itemCount: empresasFiltradas.length,
                      itemBuilder: (context, index) {
                        final empresa =  empresasFiltradas[index];

                        final empresasSocios = _empresasOrdenadasDosSocios(empresa);

                        return GestureDetector(
                          onTap: (){
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 250),
                                pageBuilder: (_, animation, __) => FadeTransition(opacity: animation, child: TelaEmpresasResumo(empresa: empresa,)),
                              ),
                            );

                          },
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              ...empresasSocios.map(
                                    (empresaSocio) {
                                  final empresaConvertida =
                                  EmpresasConciliadora(
                                    razaoSocial:
                                    empresaSocio
                                        .nomeEmpresaSocio,
                                    cnpj: empresaSocio
                                        .cnpjEmpresaSocio,
                                  );

                                  return EmpresaCardSimplesCnpjaWidget(
                                    empresa: empresaConvertida,
                                    listaEmpresasConciliadora:
                                    listaEmpresasConciliadora,
                                  );
                                },
                              ),
                            ],
                          ),
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