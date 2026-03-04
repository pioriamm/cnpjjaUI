import 'package:flutter/material.dart';

import '../../helprs/cores.dart';
import '../../helprs/formatadores.dart';
import '../../model/empresa_socio.dart';

class EmpresaItem extends StatefulWidget {
  final EmpresaSocio emp;
  final String razaoSocial;
  final Row opcoes;

  const EmpresaItem({
    super.key,
    required this.emp,
    required this.razaoSocial,
    required this.opcoes,
  });

  @override
  State<EmpresaItem> createState() => _EmpresaItemState();
}

class _EmpresaItemState extends State<EmpresaItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final emp = widget.emp;

    final bool eConciliadora = emp.eConciliadora ?? false;

    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isHover ? Colors.green.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHover ? Colors.green.shade300 : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.apartment_outlined,
              color: eConciliadora ? Cores.verde_claro : Colors.grey.shade700,
            ),

            const SizedBox(width: 12),

            /// ================= CONTEÚDO =================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NOME
                  Text(
                    emp.nomeEmpresaSocio ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),

                  /// CNPJ
                  Row(
                    children: [
                      Icon(Icons.work, size: 16, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      Text(
                        Formatadores.formatarCnpj(emp.cnpjEmpresaSocio ?? ''),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// TELEFONES
                  if (emp.telefone?.isNotEmpty ?? false)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 16,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            emp.telefone!
                                .where((t) => t.number?.isNotEmpty ?? false)
                                .map((t) {
                                  final area = t.area ?? '';
                                  final numero = Formatadores.formatarNumero(
                                    t.number!,
                                  );
                                  return '($area) $numero';
                                })
                                .join('\n'),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),

                  /// EMAILS
                  if (emp.email?.isNotEmpty ?? false)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 16,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            emp.email!
                                .where((e) => e.address?.isNotEmpty ?? false)
                                .map((e) => e.address!)
                                .join('\n'),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(Icons.sell_outlined, size: 15),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          Formatadores.formatarCnae(emp.cnae.id.toString()),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),

                      const SizedBox(width: 10),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          emp.cnae?.descricao ?? 'CNAE não informado',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// INFO RAIZ
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Cores.verde_escuro),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "Dados originados da empresa raiz: ${widget.razaoSocial}",
                          style: TextStyle(color: Cores.verde_escuro),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// OPÇÕES
            widget.opcoes,
          ],
        ),
      ),
    );
  }
}
