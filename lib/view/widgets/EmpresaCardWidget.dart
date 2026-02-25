import 'package:flutter/material.dart';
import 'package:proj_flutter/model/EmpresasConciliadora.dart';
import '../../helprs/Cores.dart';
import '../../model/EmpresaSocio.dart';
import '../../model/Membo.dart';
import 'EmpresaItem.dart';
import 'ImageIconButtonWidget.dart';

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
  final List<Membro>? empresasVinculadas;
  final List<EmpresasConciliadora> listaEmpresaBaseConciliadora;

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
    this.pipedrive,
    required this.empresasVinculadas,
    required this.listaEmpresaBaseConciliadora,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,

        /// ================= HEADER =================
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ÍCONE
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.apartment_outlined,
                color: Cores.verde_escuro,
              ),
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

                  Row(
                    children: [
                      _tag(cnpj),
                      const SizedBox(width: 10),
                      _tag(cnae, icon: Icons.sell_outlined),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    atividade,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// CONTATOS + SOCIOS
                  Wrap(
                    spacing: 20,
                    runSpacing: 6,
                    children: [
                      /// TELEFONE (AGORA TEXT)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.phone, size: 16),
                          const SizedBox(width: 6),
                          ConstrainedBox(
                            constraints:
                            const BoxConstraints(maxWidth: 200),
                            child: Text(
                              telefone,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      /// EMAIL
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.email_outlined, size: 16),
                          const SizedBox(width: 6),
                          ConstrainedBox(
                            constraints:
                            const BoxConstraints(maxWidth: 220),
                            child: Text(
                              email,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      /// SÓCIOS
                      /// SÓCIOS EM CHIPS (CORRETO)
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
                                .map((s) => _chipSocio(s))
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
                  for (var empresa in (empresasVinculadas
                      ?.expand((m) => m.empresas ?? [])
                      .where((e) =>
                  e.nomeEmpresaSocio != razaoSocial)
                      .toList() ??
                      []))
                    empresa.cnpjEmpresaSocio: empresa
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

                    final existe =
                    listaEmpresaBaseConciliadora.any(
                          (empresa) =>
                      empresa.cnpj == emp.cnpjEmpresaSocio,
                    );

                    return EmpresaItem(
                      emp: emp,
                      razaoSocial: razaoSocial,
                      ListaEmpresaBaseConciliadora:
                      listaEmpresaBaseConciliadora,
                      opcoes: Row(
                        children: [
                          if (existe)
                            ImageIconButton(
                              imagePath:
                              'assets/img/conciliadora_icon.jpeg',
                              onPressed: () {},
                            )
                          else
                            ImageIconButton(
                              imagePath:
                              'assets/img/pipedrive_icon.png',
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

  /// TAG
  Widget _tag(String texto, {IconData? icon}) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14),
            const SizedBox(width: 4)
          ],
          Text(
            texto,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _chipSocio(String nome) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        nome,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}