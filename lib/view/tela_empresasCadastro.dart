import 'package:flutter/material.dart';
import 'package:proj_flutter/helprs/formatadores.dart';
import 'package:proj_flutter/model/enum_MenuItem.dart';
import 'package:proj_flutter/model/prospec.dart';
import 'package:proj_flutter/modelview/buscarApiMongo.dart';
import 'package:proj_flutter/view/widgets/EmpresaCardWidget.dart';
import 'package:proj_flutter/view/widgets/FiltroBuscaWidget.dart';
import 'package:proj_flutter/view/widgets/SideBarWidget.dart';
import 'package:proj_flutter/view/widgets/botao_padrao.dart';
import 'package:proj_flutter/view/widgets/dialogs/NovaEmpresaDialog.dart';
import '../helprs/Cores.dart';

class TelaEmpresasCadastro extends StatefulWidget {
  const TelaEmpresasCadastro({super.key});

  @override
  State<TelaEmpresasCadastro> createState() => _TelaEmpresasCadastroState();
}

class _TelaEmpresasCadastroState extends State<TelaEmpresasCadastro> {
  List<Prospectar> empresas = [];
  List<Prospectar> empresasFiltradas = [];
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
                        final empresaAtual = empresa.dados?.isNotEmpty == true ? empresa.dados!.first : null;

                        return EmpresaCardWidget(
                          razaoSocial: empresaAtual?.empresaRaiz ?? '',
                          nomeFantasia: empresaAtual?.alias ?? "${empresaAtual?.empresaRaiz}",
                          cnpj: Formatadores.formatarCnpj("${empresaAtual?.cnpjRaizId}") ?? '',
                          cnae: Formatadores.formatarCnae("${empresaAtual?.cnae?.id!}") ?? '',
                          atividade: empresaAtual?.cnae?.descricao ?? '',
                          telefone: SizedBox(
                            height: 10,
                            child: ListView.builder(
                              itemCount: empresaAtual?.telefone?.length ?? 0,
                              itemBuilder: (context, i) {
                                final tel = empresaAtual!.telefone![i];
                                return Text(
                                  "(${tel.area ?? ''}) ${tel.number ?? ''}",
                                  style: const TextStyle(fontSize: 13),
                                );
                              },
                            ),
                          ),
                          email: empresaAtual?.email?.isNotEmpty == true
                              ? empresaAtual?.email?.first.address ?? ''
                              : '',
                          socios: empresaAtual?.membros?.map((m) => m.nomeMembro ?? '').toList() ?? [],

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
