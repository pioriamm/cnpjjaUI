import 'package:flutter/material.dart';

import 'package:proj_flutter/helprs/Cores.dart';
import 'package:proj_flutter/view/widgets/ClienteCardWidget.dart';
import 'package:proj_flutter/view/widgets/FiltroBuscaWidget.dart';
import 'package:proj_flutter/view/widgets/SideBarWidget.dart';
import 'package:proj_flutter/view/widgets/botao_padrao.dart';
import 'package:proj_flutter/view/widgets/dialogs/NovoSocioDialog.dart';

import '../model/Dados.dart';
import '../model/Membo.dart';
import '../model/enum_MenuItem.dart';
import '../model/prospec.dart';
import '../modelview/buscarApiMongo.dart';


class TelaSocioCadastro extends StatefulWidget {
  const TelaSocioCadastro({super.key});

  @override
  State<TelaSocioCadastro> createState() => _TelaSocioCadastroState();
}

class _TelaSocioCadastroState extends State<TelaSocioCadastro> {
  MenuItem _selected = MenuItem.sociosCadastro;

  List<Prospectar> empresas = [];
  List<Membro> socios = [];
  List<Membro> sociosFiltrados = [];

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
      final resultado = await BuscarApiMongo.buscarDadosMongo();

      /// ===============================
      /// FLATTEN → EMPRESAS → DADOS → MEMBROS
      /// ===============================
      final List<Membro> todosSocios = resultado
          .expand<Dados>((p) => p.dados ?? <Dados>[])
          .expand<Membro>((d) => d.membros ?? <Membro>[])
          .toList();

      /// ===============================
      /// REMOVE DUPLICADOS (POR ID OU NOME)
      /// ===============================
      final sociosUnicosMap = <String, Membro>{};

      for (final socio in todosSocios) {
        final chave = socio.idMembro ?? socio.nomeMembro ?? '';

        if (chave.isNotEmpty) {
          sociosUnicosMap[chave] = socio;
        }
      }

      final List<Membro> sociosUnicos = sociosUnicosMap.values.toList();

      /// ===============================
      /// ORDENA ALFABETICAMENTE
      /// ===============================
      sociosUnicos.sort((a, b) => (a.nomeMembro ?? '').toLowerCase().compareTo((b.nomeMembro ?? '').toLowerCase()));

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
                    children: [
                      Text(
                        "Sócios",
                        style: TextStyle(fontSize: 30, color: Cores.verde_escuro, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      BotaoPadrao(
                        acao: () async {
                          await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const NovoSocioDialog(),
                          );
                        },
                        cor: Cores.verde_escuro,
                        conteudo: [
                          Icon(Icons.add, color: Cores.branco),
                          const SizedBox(width: 8),
                          Text("Novo Sócio", style: TextStyle(color: Cores.branco, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text("${sociosFiltrados.length} sócios cadastrados", style: const TextStyle(fontSize: 15)),

                  const SizedBox(height: 15),

                  FiltroBuscaWidget(
                    controller: _filtroController,
                    onChanged: _filtrar,
                    hintText: 'Filtrar por nome...',
                  ),

                  const SizedBox(height: 15),

                  /// LISTA
                  Expanded(
                    child: carregando
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: sociosFiltrados.length,
                            itemBuilder: (context, index) {
                              final socio = sociosFiltrados[index];
                              return ClienteCardWidget(
                                nome: socio.nomeMembro ?? '',
                                cpf: socio.idMembro ?? "",
                                telefone: '',
                                email: '',
                                quantidadeEmpresas: socio.empresas?.length ?? 0,
                                onEdit: () {
                                  print("Editar ${socio.nomeMembro}");
                                },
                                onDelete: () {
                                  print("Excluir ${socio.nomeMembro}");
                                },
                                empresas: socio.empresas ?? [],
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
