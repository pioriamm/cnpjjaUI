import 'package:flutter/material.dart';
import 'package:proj_flutter/Views/widgets/EmpresaCardWidget.dart';
import 'package:proj_flutter/Views/widgets/FiltroBuscaWidget.dart';
import 'package:proj_flutter/Views/widgets/dialogs/NovaEmpresaDialog.dart';
import 'package:proj_flutter/Views/widgets/SideBarWidget.dart';
import 'package:proj_flutter/Views/widgets/botao_padrao.dart';
import 'package:proj_flutter/helprs/formatadores.dart';

import '../../models/prospectar.dart';
import '../Models/enum_MenuItem.dart';
import '../ModerViews/buscarApiMongo.dart';
import '../helprs/Cores.dart';

class TelaEmpresas extends StatefulWidget {
  const TelaEmpresas({super.key});

  @override
  State<TelaEmpresas> createState() => _TelaEmpresasState();
}

class _TelaEmpresasState extends State<TelaEmpresas> {
  List<Prospectar> empresas = [];
  List<Prospectar> empresasFiltradas = [];

  bool carregando = true;
  String? erro;

  final TextEditingController _filtroController = TextEditingController();

  MenuItem _selected = MenuItem.socios;

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

  Future<void> _carregarEmpresas() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultado = await BuscarApiMongo.buscarDadosMongo();

      setState(() {
        empresas = resultado;
        empresasFiltradas = List.from(resultado);
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

  @override
  Widget build(BuildContext context) {
    final tela = MediaQuery.of(context).size;

    /// LOADING
    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    /// ERRO
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
              padding: EdgeInsets.symmetric(horizontal: tela.width * 0.09, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Empresas",
                        style: TextStyle(fontSize: 30, color: Cores.verde_escuro, fontWeight: FontWeight.bold),
                      ),
                      BotaoPadrao(
                        acao: () async {
                          final resultado = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const NovaEmpresaDialog(),
                          );

                          /// reload após cadastro
                          if (resultado != null) {
                            _carregarEmpresas();
                          }
                        },
                        cor: Cores.verde_escuro,
                        conteudo: [
                          Icon(Icons.add, color: Cores.branco),
                          const SizedBox(width: 8),
                          Text("Nova Empresa", style: TextStyle(color: Cores.branco, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// CONTADOR
                  Text("${empresasFiltradas.length} empresas cadastradas", style: const TextStyle(fontSize: 15)),

                  const SizedBox(height: 15),

                  /// FILTRO
                  FiltroBuscaWidget(
                    controller: _filtroController,
                    onChanged: (valor) {
                      final busca = valor.toLowerCase();

                      setState(() {
                        empresasFiltradas = empresas.where((empresa) {
                          final dados = empresa.dados?.isNotEmpty == true ? empresa.dados!.first : null;

                          return (dados?.empresaRaiz ?? '').toLowerCase().contains(busca) ||
                              (dados?.alias ?? '').toLowerCase().contains(busca) ||
                              (dados?.cnpjRaizId ?? '').contains(busca);
                        }).toList();
                      });
                    },
                    hintText: 'Filtrar por razão social, nome fantasia ou CNPJ...',
                  ),

                  const SizedBox(height: 15),

                  /// LISTA
                  Expanded(
                    child: ListView.builder(
                      itemCount: empresasFiltradas.length,
                      itemBuilder: (context, index) {
                        final empresa = empresasFiltradas[index];

                        final dados = empresa.dados?.isNotEmpty == true ? empresa.dados!.first : null;

                        return EmpresaCardWidget(
                          razaoSocial: dados?.empresaRaiz ?? '',
                          nomeFantasia: dados?.alias ?? '',
                          cnpj: Formatadores.formatarCnpj("${dados?.cnpjRaizId }")?? '',
                          cnae: '',
                          atividade: '',
                          telefone: SizedBox(
                            height: 60,
                            child: ListView.builder(
                              itemCount: dados?.telefone?.length ?? 0,
                              itemBuilder: (context, i) {
                                final tel = dados!.telefone![i];
                                return Text(
                                  "(${tel.area ?? ''}) ${tel.number ?? ''}",
                                  style: const TextStyle(fontSize: 13),
                                );
                              },
                            ),
                          ),
                          email: dados?.email?.isNotEmpty == true ? dados?.email?.first.address ?? '' : '',
                          socios: dados?.membros?.map((m) => m.nomeMembro ?? '').toList() ?? [],

                          onEdit: () {},
                          onDelete: () {},
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
