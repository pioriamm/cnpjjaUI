
import 'package:cnpjjaUi/view/widgets/SideBarWidget.dart';
import 'package:flutter/material.dart';

import '../model/enum_MenuItem.dart';
import '../model/EmpresasConciliadora.dart';
import 'package:cnpjjaUi/helprs/Cores.dart';
import '../modelview/buscarApiMongo.dart';
import 'EmpresaCardWidget.dart';

class TelaPesquisarBase extends StatefulWidget {
  const TelaPesquisarBase({super.key});

  @override
  State<TelaPesquisarBase> createState() => _TelaPesquisarBaseState();
}

class _TelaPesquisarBaseState extends State<TelaPesquisarBase> {
  MenuItem _selected = MenuItem.pesquisarBase;
  List<EmpresasConciliadora> BaseConciliadora = [];

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

  Future<void> _carregarEmpresas() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultado = await BuscarApiMongo.buscarBaseConciliadora();
      BaseConciliadora = resultado;
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

    return Scaffold(
      body: Row(
        children: [
          /// SIDEBAR
          SizedBox(
            width: tela.width * 0.2,
            child: SideBarWidget(
              selectedItem: _selected,
              onItemSelected: (item) {
                setState(() => _selected = _selected);
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
                        "Carregar Base",
                        style: TextStyle(
                          fontSize: 30,
                          color: Cores.verde_escuro,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    "${BaseConciliadora.length} Empresas Pendentes de Pesquisa",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 15),

                  /// LISTA CONTROLADA
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        /// ERRO
                        if (erro != null) {
                          return Center(child: Text("Erro: $erro"));
                        }

                        /// LOADING
                        if (carregando) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        /// VAZIO
                        if (BaseConciliadora.isEmpty) {
                          return const Center(
                            child: Text("Nenhum sócio encontrado"),
                          );
                        }

                        return ListView.builder(
                          itemCount: BaseConciliadora.length,
                          itemBuilder: (context, index) {
                            final empresaConciliadora = BaseConciliadora[index];

                            return EmpresaCardWidget(
                              cnpj: empresaConciliadora.cnpj ?? "",
                              razaoSocial: empresaConciliadora.razaoSocial ?? "",
                              alias: empresaConciliadora.alias ?? "",
                              cnae: empresaConciliadora.cna ?? "",
                              cnaDescricao: empresaConciliadora.cnaDescricao ?? "",
                              pesquisado: empresaConciliadora.pesquisado ?? false,
                              conciliadora: empresaConciliadora.conciliadora ?? false,
                              id: empresaConciliadora.id ?? "",
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
