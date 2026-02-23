import 'package:flutter/material.dart';

import '../../helprs/Cores.dart';
import '../../helprs/baseConciliadora.dart';
import '../../model/EmpresasConciliadora.dart';
import '../../modelview/buscarApiMongo.dart';
import 'BotaoCnpjJa.dart';
import 'ImageIconButtonWidget.dart';

class EmpresaCardSimplesWidget extends StatelessWidget {
  final String razaoSocial;
  final String nomeFantasia;
  final String cnpj;
  final bool cnpjJa;
  final EmpresasConciliadora empresasConciliadora;

  const EmpresaCardSimplesWidget({
    super.key,
    required this.razaoSocial,
    required this.nomeFantasia,
    required this.cnpj,
    required this.cnpjJa, required this.empresasConciliadora,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Ícone
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.apartment_outlined, color: Cores.verde_escuro),
              ),

              const SizedBox(width: 14),

              /// TITULOS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(razaoSocial, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(nomeFantasia, style: TextStyle(color: Colors.grey.shade700)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _tag(cnpj),
                      ],
                    ),
                  ],
                ),
              ),

              /// AÇÕES
              Row(
                children: [
                  if (!empresasConciliadora.pesquisado!)
                    BotaoCnpjJa(empresasConciliadora: empresasConciliadora,),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// TAG (CNPJ / CNAE)
  Widget _tag(String texto, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Cores.verde_claro_W100, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14), const SizedBox(width: 4)],
          Text(texto, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
