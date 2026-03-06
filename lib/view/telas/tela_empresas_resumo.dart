import 'package:cnpjjaUi/helprs/cores.dart';
import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/model/enum_menu_item.dart';
import 'package:cnpjjaUi/model/membo.dart';
import 'package:cnpjjaUi/model/prospec.dart';
import 'package:cnpjjaUi/model/telefone.dart';
import 'package:cnpjjaUi/view/widgets/empresa_card_widget.dart';
import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';
import 'package:flutter/material.dart';

class TelaEmpresasResumo extends StatefulWidget {
  final Prospectar? empresa;

  const TelaEmpresasResumo({super.key, required this.empresa});

  @override
  State<TelaEmpresasResumo> createState() => _TelaEmpresasResumoState();
}

class _TelaEmpresasResumoState extends State<TelaEmpresasResumo> {
  MenuItem _selected = MenuItem.empresas;

  /// Getter seguro
  dynamic get empresaAtual {
    final dados = widget.empresa?.dados;
    if (dados != null && dados.isNotEmpty) {
      return dados.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final tela = MediaQuery.of(context).size;
    final empresa = empresaAtual;

    /// ✅ AGORA JÁ VEM TIPADO DO MODEL
    final List<Telefone> telefones = empresa?.telefone ?? [];
    final List<Membros> membros = empresa?.membros ?? [];

    return SelectionArea(
      child: Scaffold(
        body: Row(
          children: [
            /// SIDEBAR
            SizedBox(
              width: tela.width * 0.2,
              child: SideBarWidget(
                selectedItem: _selected,
                onItemSelected: (item) => setState(() => _selected = item),
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
                      "Resumo da Empresa",
                      style: TextStyle(
                        fontSize: 30,
                        color: Cores.verde_escuro,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Expanded(
                      child: ListView(
                        children: [
                          Theme(
                            data: Theme.of(context).copyWith(
                              dividerColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: EmpresaCardWidget(
                              razaoSocial: empresa?.empresaRaiz ?? '',
                              nomeFantasia:
                                  (empresa?.alias?.isNotEmpty ?? false)
                                  ? empresa!.alias!
                                  : empresa?.empresaRaiz ?? '',
                              cnpj: empresa?.cnpjRaizId != null
                                  ? Formatadores.formatarCnpj(
                                      empresa!.cnpjRaizId!,
                                    )
                                  : '',
                              cnae: empresa?.cnae?.id != null
                                  ? Formatadores.formatarCnae(
                                      empresa!.cnae!.id.toString(),
                                    )
                                  : '',
                              atividade: empresa?.cnae?.descricao ?? '',
                              telefone: telefones
                                  .map(
                                    (tel) =>
                                        "(${tel.area ?? ''}) ${tel.number ?? ''}",
                                  )
                                  .join(' • '),
                              email: (empresa?.email?.isNotEmpty ?? false)
                                  ? empresa!.email!.first.address ?? ''
                                  : 'Sem informações',
                              socios: membros
                                  .map((m) => m.nomeMembro ?? '')
                                  .toList(),
                              conciliadora: empresa?.eConciliadora ?? false,
                              empresasVinculadas: membros, ativoConciliadora: empresa.ativoConciliadora ?? false
                            ),
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
      ),
    );
  }
}
