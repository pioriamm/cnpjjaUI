import 'package:cnpjjaUi/view/widgets/pilula_conciliadora.dart';
import 'package:flutter/material.dart';

import '../../helprs/cores.dart';
import '../../model/empresa_socio.dart';
import '../../model/membo.dart';
import 'Image_icon_button_widget.dart';
import 'empresa_item.dart';

class EmpresaCardWidget extends StatelessWidget {
  final String razaoSocial;
  final String nomeFantasia;
  final String cnpj;
  final String cnae;
  final String atividade;
  final String telefone;
  final String email;
  final List<String> socios;
  final VoidCallback? pipedrive;
  final List<Membros>? empresasVinculadas;
  final bool conciliadora;
  final bool? ativoConciliadora;

  const EmpresaCardWidget({
    super.key,
    required this.razaoSocial,
    required this.nomeFantasia,
    required this.cnpj,
    required this.cnae,
    required this.atividade,
    required this.telefone,
    required this.email,
    required this.socios,
    required this.empresasVinculadas,
    required this.conciliadora,
    this.pipedrive,
    this.ativoConciliadora,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color:  Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        collapsedBackgroundColor: Colors.grey.shade100,

        /// ================= HEADER =================
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.apartment_outlined, color: Cores.verde_escuro),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    razaoSocial,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    nomeFantasia,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 10,
                    children: [
                      _tag(cnpj),
                      _tag(cnae, icon: Icons.sell_outlined),
                      if (conciliadora) PilulaConciliadora(),
                      ativoConciliadora! ? const SizedBox() : PilulaConciliadora( cor: Cores.vermelho,),

                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    atividade,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 20,
                    runSpacing: 6,
                    children: [
                      _infoItem(Icons.phone, telefone, 200),
                      _infoItem(Icons.email_outlined, email, 220),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.group_outlined, size: 16),
                              SizedBox(width: 6),
                              Text(
                                "SÓCIOS",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: socios
                                .where((s) => s.trim().isNotEmpty)
                                .map(_chipSocio)
                                .toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        /// ================= EXPANSÃO =================
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Builder(
              builder: (context) {
                final empresas = {
                  for (var empresa
                      in (empresasVinculadas
                              ?.expand((m) => m.empresas ?? [])
                              .where((e) => e.nomeEmpresaSocio != razaoSocial)
                              .toList() ??
                          []))
                    empresa.cnpjEmpresaSocio: empresa,
                }.values.toList();

                if (empresas.isEmpty) {
                  return const Text("Nenhuma empresa vinculada");
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: empresas.length,
                  itemBuilder: (context, index) {
                    final EmpresaSocio emp = empresas[index];

                    /// 🔥 AGORA USA DIRETO A PROPRIEDADE
                    final bool existe = emp.eConciliadora ?? false;

                    return EmpresaItem(
                      emp: emp,
                      razaoSocial: razaoSocial,
                      opcoes: Row(
                        children: [
                          existe
                              ? ImageIconButton(
                                  imagePath:
                                      'assets/img/conciliadora_icon.jpeg',
                                  onPressed: () {},
                                )
                              : ImageIconButton(
                                  imagePath: 'assets/img/pipedrive_icon.png',
                                  onPressed: pipedrive,
                                ),
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
    );
  }

  Widget _tag(String texto, {IconData? icon, Color? cor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cor ?? Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14), const SizedBox(width: 4)],
          Text(texto, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _infoItem(IconData icon, String texto, double maxWidth) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Text(texto, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  Widget _chipSocio(String nome) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(nome, style: const TextStyle(fontSize: 13)),
    );
  }
}
