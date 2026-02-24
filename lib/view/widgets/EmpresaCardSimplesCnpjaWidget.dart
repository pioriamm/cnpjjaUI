import 'package:flutter/material.dart';
import 'package:proj_flutter/helprs/formatadores.dart';
import 'package:proj_flutter/model/EmpresasConciliadora.dart';
import '../../helprs/Cores.dart';
import 'BotaoCnpjJa.dart';

class EmpresaCardSimplesCnpjaWidget extends StatelessWidget {
  final EmpresasConciliadora empresa;
  final List<EmpresasConciliadora> listaEmpresasConciliadora;

  const EmpresaCardSimplesCnpjaWidget({
    super.key,
    required this.empresa,
    required this.listaEmpresasConciliadora,
  });

  /// ================= NORMALIZA CNPJ
  String _normalizarCnpj(String? cnpj) {
    return (cnpj ?? '').replaceAll(RegExp(r'[.\-/]'), '');
  }

  /// ================= INFO ROW
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

    final razaoSocial = emp.razaoSocial ?? '';
    final nomeFantasia = emp.alias ?? emp.razaoSocial ?? '';

    /// ================= VERIFICA SE EXISTE NA LISTA CONCILIADORA
    final cnpjAtual = _normalizarCnpj(emp.cnpj);

    final existeNaConciliadora = listaEmpresasConciliadora.any((e) {
      return _normalizarCnpj(e.cnpj) == cnpjAtual;
    });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ÍCONE
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.apartment_outlined,
                  color: Cores.verde_escuro,
                ),
              ),

              const SizedBox(width: 12),

              /// TEXTO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      razaoSocial,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      nomeFantasia,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    Divider(),
                    SizedBox(height: 20),
                    _info(
                      Icons.badge_outlined,
                      Formatadores.formatarCnpj(emp.cnpj ?? ''),
                    ),
                    _info(Icons.sell_outlined, emp.cnaDescricao),
                    _info(Icons.numbers, emp.cna?.toString()),
                    _info(Icons.fingerprint, emp.iId?.oid),
                  ],
                ),
              ),

              existeNaConciliadora
                  ? Container(
                      width: 110,
                      height: 35,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Cores.verde_claro_W40,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/img/conciliadora_icon.jpeg',
                          width: 70,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Container(
                      width: 110,
                      height: 35,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Não conciliada",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
            ],
          ),

          /// DADOS
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
