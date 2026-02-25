import 'package:flutter/material.dart';
import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/model/enum_MenuItem.dart';
import 'package:cnpjjaUi/model/prospec.dart';
import 'package:cnpjjaUi/modelview/buscarApiMongo.dart';
import 'package:cnpjjaUi/view/widgets/EmpresaCardWidget.dart';
import 'package:cnpjjaUi/view/widgets/FiltroBuscaWidget.dart';
import 'package:cnpjjaUi/view/widgets/SideBarWidget.dart';
import '../helprs/Cores.dart';
import '../model/EmpresasConciliadora.dart';

class TelaEmpresas extends StatefulWidget {
  const TelaEmpresas({super.key});

  @override
  State<TelaEmpresas> createState() => _TelaEmpresasState();
}

class _TelaEmpresasState extends State<TelaEmpresas> {
  List<Prospectar> empresas = [];
  List<Prospectar> empresasFiltradas = [];
  List<EmpresasConciliadora> listaEmpresaBaseConciliadora = [];

  bool carregando = true;
  String? erro;

  final TextEditingController _filtroController = TextEditingController();
  MenuItem _selected = MenuItem.empresas;

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
      final resultado =
      await BuscarApiMongo.buscarEmpresasBaseCnpjja();

      final baseConciliadora =
      await BuscarApiMongo.buscarBaseConciliadora();

      setState(() {
        empresas = resultado;
        empresasFiltradas = List.from(resultado);
        listaEmpresaBaseConciliadora = baseConciliadora;
      });
    } catch (e) {
      setState(() => erro = e.toString());
    } finally {
      setState(() => carregando = false);
    }
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
            child: SideBarWidget(
              selectedItem: _selected,
              onItemSelected: (item) =>
                  setState(() => _selected = item),
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
                    "Empresas",
                    style: TextStyle(
                      fontSize: 30,
                      color: Cores.verde_escuro,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${empresasFiltradas.length} empresas cadastradas",
                    style: const TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 15),

                  /// FILTRO
                  FiltroBuscaWidget(
                    controller: _filtroController,
                    hintText:
                    'Filtrar por razão social, nome fantasia ou CNPJ...',
                    onChanged: (valor) {
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
                              (dados?.cnpjRaizId ?? '')
                                  .contains(busca);
                        }).toList();
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  /// LISTA
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (erro != null) {
                          return Center(child: Text("Erro: $erro"));
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
                            final empresaAtual =
                            empresa.dados?.isNotEmpty == true
                                ? empresa.dados!.first
                                : null;

                            /// 🔥 REMOVE LINHA DO EXPANSION TILE
                            return Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: EmpresaCardWidget(
                                razaoSocial:
                                empresaAtual?.empresaRaiz ?? '',
                                nomeFantasia:
                                empresaAtual?.alias ??
                                    "${empresaAtual?.empresaRaiz}",
                                cnpj: Formatadores.formatarCnpj(
                                    "${empresaAtual?.cnpjRaizId}"),
                                cnae: Formatadores.formatarCnae(
                                    "${empresaAtual?.cnae?.id!}") ??
                                    '',
                                atividade:
                                empresaAtual?.cnae?.descricao ?? '',
                                telefone: empresaAtual!.telefone!
                                    .map((tel) =>
                                "(${tel.area ?? ''}) ${tel.number ?? ''}")
                                    .join(' • '),
                                email: empresaAtual
                                    ?.email?.isNotEmpty ==
                                    true
                                    ? empresaAtual!
                                    .email!.first.address ??
                                    ''
                                    : 'Sem informações',
                                socios: empresaAtual?.membros
                                    ?.map((m) =>
                                m.nomeMembro ?? '')
                                    .toList() ??
                                    [],
                                empresasVinculadas:
                                empresaAtual!.membros!,
                                listaEmpresaBaseConciliadora:
                                listaEmpresaBaseConciliadora,
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