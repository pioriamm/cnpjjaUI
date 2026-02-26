import 'package:flutter/material.dart';
import 'package:cnpjjaUi/helprs/formatadores.dart';
import '../../helprs/cores.dart';
import '../../model/empresa_socio.dart';

class EmpresaCardSimplesCnpjaWidget extends StatelessWidget {
  final EmpresaSocio empresa;

  const EmpresaCardSimplesCnpjaWidget({super.key, required this.empresa});

  Widget _info(IconData icon, String? texto) {
    if (texto == null || texto.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 6),
          Expanded(
            child: Text(texto, style: TextStyle(fontSize: 12, color: Colors.grey.shade800)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emp = empresa;

    final bool eConciliadora = emp.eConciliadora ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.05))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.apartment_outlined, color: Cores.verde_escuro),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.nomeEmpresaSocio ?? '', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),

                const SizedBox(height: 8),

                _info(Icons.badge_outlined, Formatadores.formatarCnpj(emp.cnpjEmpresaSocio ?? '')),

                _info(Icons.sell_outlined, emp.cnae?.descricao),
              ],
            ),
          ),

          eConciliadora
              ? Container(
                  width: 110,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Cores.verde_claro_W40, borderRadius: BorderRadius.circular(20)),
                  child: Image.asset('assets/img/conciliadora_icon.jpeg', width: 70, height: 35, fit: BoxFit.cover),
                )
              : Container(
                  width: 110,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
                  child: const Text("Não conciliada", style: TextStyle(fontSize: 12)),
                ),
        ],
      ),
    );
  }
}
