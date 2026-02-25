import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cnpjjaUi/model/enum_MenuItem.dart';
import 'package:cnpjjaUi/modelview/buscarApiMongo.dart';
import 'package:cnpjjaUi/view/widgets/EmpresaCardSimplesCnpjaWidget.dart';
import 'package:cnpjjaUi/view/widgets/FiltroBuscaWidget.dart';
import 'package:cnpjjaUi/view/widgets/SideBarWidget.dart';

import '../helprs/Cores.dart';
import '../model/EmpresasConciliadora.dart';
import '../model/prospec.dart';

class TelaEmpresasSocio extends StatefulWidget {
  const TelaEmpresasSocio({super.key});

  @override
  State<TelaEmpresasSocio> createState() => _TelaEmpresasSocioState();
}

enum FiltroCliente { todos, cliente, naoCliente }

class _TelaEmpresasSocioState extends State<TelaEmpresasSocio> {
  List<Prospectar> empresas = [];
  List<Prospectar> empresasFiltradas = [];
  List<EmpresasConciliadora> listaEmpresasConciliadora = [];


  Map<String, bool> mapaClientes = {};

  bool carregando = true;
  String? erro;

  final TextEditingController _filtroController = TextEditingController();

  MenuItem _selected = MenuItem.empresaSocio;
  FiltroCliente _filtroCliente = FiltroCliente.todos;

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
  /// CARREGAR DADOS
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

      /// cria mapa rápido
      final mapa = {
        for (final e in listaConciliadora)
          if (e.cnpj != null) e.cnpj!: e.conciliadora == true
      };

      resultado.sort(
            (a, b) => _razaoSocial(a)
            .toLowerCase()
            .compareTo(_razaoSocial(b).toLowerCase()),
      );

      setState(() {
        empresas = resultado;
        empresasFiltradas = List.from(resultado);
        listaEmpresasConciliadora = listaConciliadora;
        mapaClientes = mapa;
      });
    } catch (e) {
      setState(() => erro = e.toString());
    } finally {
      setState(() => carregando = false);
    }
  }

  /// =====================================================
  /// RAZÃO SOCIAL
  /// =====================================================
  String _razaoSocial(Prospectar p) {
    final dados = p.dados?.isNotEmpty == true ? p.dados!.first : null;
    return dados?.empresaRaiz ?? '';
  }


  bool _empresaEhCliente(Prospectar empresa) {
    final dados =
    empresa.dados?.isNotEmpty == true ? empresa.dados!.first : null;
    final cnpj = dados?.cnpjRaizId;
    if (cnpj == null) return false;

    return mapaClientes[cnpj] ?? false;
  }


  void _aplicarFiltros() {
    final busca = _filtroController.text.toLowerCase();

    setState(() {
      empresasFiltradas = empresas.where((empresa) {
        final dados =
        empresa.dados?.isNotEmpty == true ? empresa.dados!.first : null;


        final matchTexto =
            (dados?.empresaRaiz ?? '').toLowerCase().contains(busca) ||
                (dados?.alias ?? '').toLowerCase().contains(busca) ||
                (dados?.cnpjRaizId ?? '').contains(busca);

        /// consulta lista conciliadora
        final ehCliente = _empresaEhCliente(empresa);

        bool matchCliente = true;

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
      }).toList();
    });
  }


  List<dynamic> _empresasOrdenadasDosSocios(Prospectar prospectar) {
    final dados = prospectar.dados?.isNotEmpty == true
        ? prospectar.dados!.first
        : null;

    if (dados == null) return [];

    final todas =
        dados.membros?.expand((m) => m.empresas ?? []).toList() ?? [];

    final mapaUnico = {
      for (var e in todas)
        if (e.cnpjEmpresaSocio != null) e.cnpjEmpresaSocio!: e,
    };

    final listaFinal = mapaUnico.values.toList();

    listaFinal.sort((a, b) => (a.nomeEmpresaSocio ?? '')
        .toLowerCase()
        .compareTo((b.nomeEmpresaSocio ?? '').toLowerCase()));

    return listaFinal;
  }

  int _totalEmpresasParceiros() {
    return empresasFiltradas.fold<int>(
      0,
          (total, empresa) =>
      total + _empresasOrdenadasDosSocios(empresa).length,
    );
  }


  @override
  Widget build(BuildContext context) {
    final tela = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: tela.width * 0.2,
            child: SideBarWidget(
              selectedItem: _selected,
              onItemSelected: (item) =>
                  setState(() => _selected = item),
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
                    "Empresas Sócios",
                    style: TextStyle(
                      fontSize: 30,
                      color: Cores.verde_escuro,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${_totalEmpresasParceiros()} empresas cadastradas",
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 15),

                  /// BUSCA + DROPDOWN
                  Row(
                    children: [
                      Expanded(
                        child: FiltroBuscaWidget(
                          controller: _filtroController,
                          onChanged: (_) => _aplicarFiltros(),
                          hintText: 'Filtrar por CNPJ ou Nome',
                        ),
                      ),

                      const SizedBox(width: 12),

                      DropdownButton<FiltroCliente>(
                        value: _filtroCliente,
                        items: const [
                          DropdownMenuItem(
                            value: FiltroCliente.todos,
                            child: Text('Todos'),
                          ),
                          DropdownMenuItem(
                            value: FiltroCliente.cliente,
                            child: Text('É cliente'),
                          ),
                          DropdownMenuItem(
                            value: FiltroCliente.naoCliente,
                            child: Text('Não é cliente'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;

                          setState(() {
                            _filtroCliente = value;
                          });

                          _aplicarFiltros();
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (erro != null) {
                          return Center(child: Text("Erro: $erro"));
                        }

                        if (carregando) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (empresasFiltradas.isEmpty) {
                          return const Center(
                              child:
                              Text("Nenhuma empresa encontrada"));
                        }

                        return ListView.builder(
                          itemCount: empresasFiltradas.length,
                          itemBuilder: (context, index) {
                            final empresa = empresasFiltradas[index];

                            final empresasSocios =
                            _empresasOrdenadasDosSocios(
                                empresa);

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
                                      empresaSocio
                                          .nomeEmpresaSocio,
                                      cnpj:
                                      empresaSocio
                                          .cnpjEmpresaSocio,
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