import 'package:flutter/material.dart';

import '../../helprs/Cores.dart';
import '../../helprs/formatadores.dart';
import '../../model/EmpresaSocio.dart';
import '../../model/EmpresasConciliadora.dart';

class EmpresaItem extends StatefulWidget {
  final EmpresaSocio emp;
  final String razaoSocial;
  final Row opcoes;
  final List<EmpresasConciliadora> ListaEmpresaBaseConciliadora;

  const EmpresaItem({
    super.key,
    required this.emp,
    required this.razaoSocial,
    required this.opcoes,
    required this.ListaEmpresaBaseConciliadora,
  });

  @override
  State<EmpresaItem> createState() => _EmpresaItemState();
}

class _EmpresaItemState extends State<EmpresaItem> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final emp = widget.emp;

    /// verifica UMA vez só (performance melhor)
    final cnaeId = "${emp.cnae?.id}0";

    final estaNaBase = cnaeId != null && widget.ListaEmpresaBaseConciliadora.any((e) => e.cna == cnaeId);

    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
          isHover ? Colors.green.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHover
                ? Colors.green.shade300
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.apartment_outlined),
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

                  const SizedBox(height: 6),

                  /// CNPJ
                  Row(
                    children: [
                      Icon(Icons.badge_outlined,
                          size: 16, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      Text(
                        Formatadores.limparCnpj(
                            emp.cnpjEmpresaSocio ?? ''),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// CNAE
                  Row(
                    children: [
                      Text(
                        emp.cnae?.descricao ?? 'CNAE não informado',
                        style: const TextStyle(fontWeight: FontWeight.w500),),
                      const SizedBox(width: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: estaNaBase
                              ? Cores.verde_claro
                              : Cores.cinza,
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.sell_outlined, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              cnaeId?.toString() ?? 'CNAE não informado', style: const TextStyle(fontWeight: FontWeight.w500,),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// TELEFONES
                  if (emp.telefone?.isNotEmpty ?? false)
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.phone_outlined,
                            size: 16,
                            color: Colors.grey.shade700),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            emp.telefone!
                                .where((t) =>
                            t.number?.isNotEmpty ??
                                false)
                                .map((t) {
                              final area = t.area ?? '';
                              final numero =
                              Formatadores.formatarNumero(
                                  t.number!);
                              return '($area) $numero';
                            }).join('\n'),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 4),

                  /// EMAILS
                  if (emp.email?.isNotEmpty ?? false)
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.email_outlined,
                            size: 16,
                            color: Colors.grey.shade700),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            emp.email!
                                .where((e) =>
                            e.address?.isNotEmpty ??
                                false)
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

                  const SizedBox(height: 10),

                  /// INFO RAIZ
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Cores.vermelho),
                      const SizedBox(width: 4),
                      Text(
                        "Os dados foram orinados da empresa raiz:",
                        style:
                        TextStyle(color: Cores.verde_escuro),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.razaoSocial,
                        style: TextStyle(
                          color: Cores.verde_escuro,
                          fontWeight: FontWeight.bold,
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