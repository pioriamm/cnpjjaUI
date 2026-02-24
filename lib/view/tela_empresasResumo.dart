import 'package:flutter/material.dart';
import 'package:proj_flutter/helprs/formatadores.dart';
import 'package:proj_flutter/model/enum_MenuItem.dart';
import 'package:proj_flutter/model/prospec.dart';
import 'package:proj_flutter/modelview/buscarApiMongo.dart';
import 'package:proj_flutter/view/widgets/EmpresaCardWidget.dart';
import 'package:proj_flutter/view/widgets/SideBarWidget.dart';

import '../helprs/Cores.dart';
import '../model/EmpresasConciliadora.dart';
import '../model/Membo.dart';
import '../model/Telefone.dart';

class TelaEmpresasResumo extends StatefulWidget {
  final Prospectar? empresa;

  const TelaEmpresasResumo({super.key, required this.empresa});

  @override
  State<TelaEmpresasResumo> createState() => _TelaEmpresasResumoState();
}

class _TelaEmpresasResumoState extends State<TelaEmpresasResumo> {
  List<EmpresasConciliadora> listaEmpresaBaseConciliadora = [];

  bool carregando = true;
  String? erro;

  final TextEditingController _filtroController = TextEditingController();
  MenuItem _selected = MenuItem.empresas;

  /// Getter seguro
  get empresaAtual {
    final dados = widget.empresa?.dados;
    if (dados != null && dados.isNotEmpty) {
      return dados.first;
    }
    return null;
  }

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
    try {
      final baseConciliadora = await BuscarApiMongo.buscarBaseConciliadora();

      if (!mounted) return;

      setState(() {
        listaEmpresaBaseConciliadora = baseConciliadora;
        carregando = false;
        erro = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        erro = e.toString();
        carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tela = MediaQuery.of(context).size;

    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (erro != null) {
      return Scaffold(body: Center(child: Text("Erro: $erro")));
    }

    final empresa = empresaAtual;

    /// ✅ TELEFONES TIPADOS
    final List<Telefone> telefones = (empresa?.telefone ?? []).map<Telefone>((e) {
      if (e is Telefone) return e;
      return Telefone.fromJson(e);
    }).toList();

    /// ✅ MEMBROS TIPADOS (CORREÇÃO DO ERRO)
    final List<Membro> membros = (empresa?.membros ?? []).map<Membro>((e) {
      if (e is Membro) return e;
      return Membro.fromJson(e);
    }).toList();

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: tela.width * 0.2,
            child: SideBarWidget(
              selectedItem: _selected,
              onItemSelected: (item) {
                setState(() => _selected = item);
              },
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tela.width * 0.09, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Resumo da Empresas",
                    style: TextStyle(fontSize: 30, color: Cores.verde_escuro, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 15),

                  Expanded(
                    child: ListView(
                      children: [
                        EmpresaCardWidget(
                          razaoSocial: empresa?.empresaRaiz ?? '',
                          nomeFantasia: (empresa?.alias?.isNotEmpty ?? false)
                              ? empresa!.alias!
                              : empresa?.empresaRaiz ?? '',
                          cnpj: empresa?.cnpjRaizId != null ? Formatadores.formatarCnpj(empresa!.cnpjRaizId!) : '',
                          cnae: empresa?.cnae?.id != null
                              ? Formatadores.formatarCnae(empresa!.cnae!.id.toString())
                              : '',
                          atividade: empresa?.cnae?.descricao ?? '',
                          telefone: SizedBox(
                            height: 40,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: telefones.length,
                              itemBuilder: (context, i) {
                                final tel = telefones[i];

                                return Text(
                                  "(${tel.area ?? ''}) ${tel.number ?? ''}",
                                  style: const TextStyle(fontSize: 13),
                                );
                              },
                            ),
                          ),
                          email: (empresa?.email?.isNotEmpty ?? false)
                              ? empresa!.email!.first.address ?? ''
                              : 'Sem informações',
                          socios: membros.map((m) => m.nomeMembro ?? '').toList(),
                          empresasVinculadas: membros,
                          ListaEmpresaBaseConciliadora: listaEmpresaBaseConciliadora,
                        ),
                      ],
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
