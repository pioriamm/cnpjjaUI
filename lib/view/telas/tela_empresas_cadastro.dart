import 'package:cnpjjaUi/model/empresas_conciliadora.dart';
import 'package:cnpjjaUi/model/enum_menu_item.dart';
import 'package:cnpjjaUi/repositorio/api_service.dart';
import 'package:cnpjjaUi/view/widgets/botao_padrao.dart';
import 'package:cnpjjaUi/view/widgets/empresa_card_simples_widget.dart';
import 'package:cnpjjaUi/view/widgets/filtro_busca_widget.dart';
import 'package:cnpjjaUi/view/widgets/nova_empresa_dialog.dart';
import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';
import 'package:flutter/material.dart';

import '../../helprs/cores.dart';

class TelaEmpresasCadastro extends StatefulWidget {
  const TelaEmpresasCadastro({super.key});

  @override
  State<TelaEmpresasCadastro> createState() => _TelaEmpresasCadastroState();
}

class _TelaEmpresasCadastroState extends State<TelaEmpresasCadastro> {
  List<EmpresasConciliadora> empresas = [];
  List<EmpresasConciliadora> empresasFiltradas = [];

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

  /// ==============================
  /// CARREGAR EMPRESAS
  /// ==============================
  Future<void> _carregarEmpresas() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultado = await ApiService.buscarBaseConciliadora();

      /// ordena por razão social
      resultado.sort(
        (a, b) => (a.razaoSocial ?? '').toLowerCase().compareTo(
          (b.razaoSocial ?? '').toLowerCase(),
        ),
      );

      setState(() {
        empresas = resultado;
        empresasFiltradas = List.from(resultado);
      });
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      setState(() {});
    }
  }

  /// ==============================
  /// FILTRO
  /// ==============================
  void _filtrar(String valor) {
    final busca = valor.toLowerCase();

    setState(() {
      empresasFiltradas = empresas.where((empresa) {
        return (empresa.razaoSocial ?? '').toLowerCase().contains(busca) ||
            (empresa.alias ?? '').toLowerCase().contains(busca) ||
            (empresa.cnpj ?? '').contains(busca) ||
            (empresa.id ?? '').toLowerCase().contains(busca);
      }).toList();
    });
  }

  /// ==============================
  /// BUILD
  /// ==============================
  @override
  Widget build(BuildContext context) {
    final tela = MediaQuery.of(context).size;

    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (erro != null) {
      return Scaffold(body: Center(child: Text("Erro: $erro")));
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lista de Empresas",
                        style: TextStyle(
                          fontSize: 30,
                          color: Cores.verde_escuro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BotaoPadrao(
                        acao: () async {
                          final resultado = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const NovaEmpresaDialog(),
                          );

                          if (resultado != null) {
                            _carregarEmpresas();
                          }
                        },
                        cor: Cores.verde_escuro,
                        conteudo: [
                          Icon(Icons.add, color: Cores.branco),
                          const SizedBox(width: 8),
                          Text(
                            "Nova Empresa",
                            style: TextStyle(color: Cores.branco, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// CONTADOR
                  Text(
                    "${empresasFiltradas.length} empresas cadastradas",
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 15),

                  /// FILTRO
                  FiltroBuscaWidget(
                    controller: _filtroController,
                    onChanged: _filtrar,
                    hintText:
                        'Filtrar por razão social, nome fantasia, CNPJ ou ID...',
                  ),

                  const SizedBox(height: 15),

                  /// LISTA
                  Expanded(
                    child: ListView.builder(
                      itemCount: empresasFiltradas.length,
                      itemBuilder: (context, index) {
                        final empresa = empresasFiltradas[index];
                        return EmpresaCardSimplesWidget(empresa: empresa);
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
