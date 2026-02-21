import 'package:flutter/material.dart';
import 'package:proj_flutter/helprs/formatadores.dart';
import 'package:proj_flutter/model/EmpresaSocio.dart';

import '../../helprs/tooltip_controller.dart';

class ClienteCardWidget extends StatefulWidget {
  final String nome;
  final String cpf;
  final String telefone;
  final String email;
  final int quantidadeEmpresas;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final List<EmpresaSocio> empresas;

  const ClienteCardWidget({
    super.key,
    required this.nome,
    required this.cpf,
    required this.telefone,
    required this.email,
    required this.quantidadeEmpresas,
    this.onEdit,
    this.onDelete,
    required this.empresas,
  });

  @override
  State<ClienteCardWidget> createState() => _ClienteCardWidgetState();
}

class _ClienteCardWidgetState extends State<ClienteCardWidget> {

  String get inicial => widget.nome.isNotEmpty ? widget.nome[0].toUpperCase() : "?";
  void _mostrarTooltip(BuildContext context) {
    final overlay = Overlay.of(context);

    final box = context.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);

    final entry = OverlayEntry(
      builder: (_) => Positioned(
        left: position.dx,
        top: position.dy + box.size.height + 8,
        child: _TooltipEmpresas(
          empresas: widget.empresas,
          onClose: TooltipController.hide,
        ),
      ),
    );

    TooltipController.show(overlay, entry);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          /// Avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF123C3C),
            child: Text(
              inicial,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(width: 16),

          /// Conteúdo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),

                const SizedBox(height: 4),

                Text(widget.cpf, style: TextStyle(color: Colors.grey.shade700)),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [const Icon(Icons.phone, size: 16), const SizedBox(width: 4), Text(widget.telefone)],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.email_outlined, size: 16),
                        const SizedBox(width: 4),
                        Text(widget.email),
                      ],
                    ),

                    /// HOVER (abre apenas)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: MouseRegion(
                        onEnter: (_) => _mostrarTooltip(context),
                        child: Text(
                          "${widget.quantidadeEmpresas} empresas",
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Ações
          Row(
            children: [
              IconButton(icon: const Icon(Icons.edit_outlined), onPressed: widget.onEdit),
              IconButton(icon: const Icon(Icons.delete_outline), onPressed: widget.onDelete),
            ],
          ),
        ],
      ),
    );
  }
}

/// =======================================================
/// TOOLTIP COM BOTÃO FECHAR + SCROLL
/// =======================================================
class _TooltipEmpresas extends StatefulWidget {
  final List<EmpresaSocio> empresas;
  final VoidCallback onClose;

  const _TooltipEmpresas({required this.empresas, required this.onClose});

  @override
  State<_TooltipEmpresas> createState() => _TooltipEmpresasState();
}

class _TooltipEmpresasState extends State<_TooltipEmpresas> {
  Offset position = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: position,
      child: GestureDetector(
        /// 🔥 ARRASTAR
        onPanUpdate: (details) {
          setState(() {
            position += details.delta;
          });
        },

        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 520,
            constraints: const BoxConstraints(maxHeight: 420),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black26)],
            ),
            child: Column(
              children: [
                /// HEADER (área ideal para drag)
                Row(
                  children: [
                    const Icon(Icons.drag_indicator),
                    const SizedBox(width: 8),
                    const Text("Empresas do Sócio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.close), onPressed: widget.onClose),
                  ],
                ),

                const SizedBox(height: 10),

                /// LISTA SCROLL
                Expanded(
                  child: ListView.separated(
                    itemCount: widget.empresas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final empresa = widget.empresas[index];

                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
                        child: Row(
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.apartment),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    empresa.nomeEmpresaSocio ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(empresa.cnpjEmpresaSocio ?? '', style: TextStyle(color: Colors.grey.shade700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
