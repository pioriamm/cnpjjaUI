import 'package:flutter/material.dart';

import '../../helprs/Cores.dart';
import '../../helprs/baseConciliadora.dart';
import 'ImageIconButtonWidget.dart';

class EmpresaCardWidget extends StatelessWidget {
  final String razaoSocial;
  final String nomeFantasia;
  final String cnpj;
  final String cnae;
  final String atividade;
  final Widget telefone;
  final String email;
  final List<String> socios;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? pipedrive;

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
    this.onEdit,
    this.onDelete,
    this.pipedrive,
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
                        const SizedBox(width: 10),
                        _tag(cnae, icon: Icons.sell_outlined),
                      ],
                    ),
                  ],
                ),
              ),

              /// AÇÕES
              Row(
                children: [
                  if (BaseConciliadora.Lista_base_conciliadora.contains(cnpj))
                    ImageIconButton(imagePath: 'assets/img/conciliadora_icon.jpeg', onPressed: () {})
                  else
                    ImageIconButton(imagePath: 'assets/img/pipedrive_icon.png', onPressed: pipedrive),
                  IconButton(icon: const Icon(Icons.edit_outlined), onPressed: onEdit),

                  IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
                ],
              ),
            ],
          ),

          const Divider(height: 28),

          /// BODY
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ATIVIDADE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ATIVIDADE", style: TextStyle(fontSize: 12, color: Colors.grey.shade600, letterSpacing: 1)),
                    const SizedBox(height: 6),
                    Text(
                      atividade,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.phone, size: 16),
                        const SizedBox(width: 6),

                        Expanded(child: SizedBox(height: 50, child: telefone)),

                        const SizedBox(width: 20),

                        const Icon(Icons.email_outlined, size: 16),
                        const SizedBox(width: 6),

                        Expanded(child: Text(email, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 20),

              /// SÓCIOS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SÓCIOS (${socios.length})",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, letterSpacing: 1),
                    ),
                    const SizedBox(height: 8),

                    Wrap(spacing: 8, runSpacing: 8, children: socios.map((s) => _chipSocio(s)).toList()),
                  ],
                ),
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
      decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 14), const SizedBox(width: 4)],
          Text(texto, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  /// CHIP SÓCIO
  Widget _chipSocio(String nome) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
      child: Text(nome),
    );
  }
}
