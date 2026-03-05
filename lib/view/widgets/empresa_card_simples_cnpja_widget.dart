import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/view/widgets/pilula_conciliadora.dart';
import 'package:flutter/material.dart';

import '../../helprs/cores.dart';
import '../../model/empresa_socio.dart';

class EmpresaCardSimplesCnpjaWidget extends StatelessWidget {
  final EmpresaSocio empresa;
  final String empresaPai;

  const EmpresaCardSimplesCnpjaWidget({
    super.key,
    required this.empresa,
    required this.empresaPai,
  });

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
            child: Text(
              texto,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
            ),
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
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.apartment_outlined, color: Cores.verde_escuro),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emp.nomeEmpresaSocio ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),
                _info(
                  Icons.work,
                  Formatadores.formatarCnpj(emp.cnpjEmpresaSocio ?? ''),
                ),
                _info(
                  Icons.badge_outlined,
                  Formatadores.formatarCnae(emp.cnae!.id.toString()),
                ),
                _info(Icons.sell_outlined, emp.cnae?.descricao),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Cores.verde_escuro),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "Dados originados da empresa raiz: ",
                            style: TextStyle(
                              color: Cores.verde_escuro,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          empresaPai.length < 50
                              ? Text(
                                  "${empresaPai}",
                                  style: TextStyle(
                                    color: Cores.verde_escuro,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  "${empresaPai.substring(0, 50)}",
                                  style: TextStyle(
                                    color: Cores.verde_escuro,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          eConciliadora
              ? PilulaConciliadora()
              : Container(
                  width: 110,
                  height: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Prospectar",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
        ],
      ),
    );
  }
}
