import 'package:flutter/material.dart';
import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/model/empresas_conciliadora.dart';
import '../../helprs/cores.dart';
import 'botao_cnpja.dart';

class EmpresaCardSimplesWidget extends StatelessWidget {
  final EmpresasConciliadora empresa;

  const EmpresaCardSimplesWidget({
    super.key,
    required this.empresa,
  });

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
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= BOTÃO PESQUISAR
  Widget _botaoPesquisar() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Cores.verde_escuro,
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        /// coloque aqui sua chamada do CNPJJA
        debugPrint("Pesquisar CNPJ ${empresa.cnpj}");
      },
      icon: const Icon(Icons.search, size: 16, color: Colors.white),
      label: const Text(
        "Pesquisar",
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  /// ================= BUILD
  @override
  Widget build(BuildContext context) {
    final emp = empresa;

    final razaoSocial = emp.razaoSocial ?? '';
    final nomeFantasia = emp.alias ?? emp.razaoSocial ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.05),
          )
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

              /// TEXTO (EXPANDE)
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
                  ],
                ),
              ),

              /// ===== GRUPO DIREITA
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// CONTAINER VERMELHO
                  Container(
                    width: 230,
                    padding: const EdgeInsets.symmetric(horizontal: 8),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        /// BOTÃO PESQUISAR
                        if (!(emp.pesquisado ?? false))
                          BotaoCnpjJa(
                            empresasConciliadora: empresa,
                          ),
                        const SizedBox(width: 10),
                        if (emp.conciliadora == true)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50), // efeito pílula
                            child: Image.asset(
                              'assets/img/conciliadora_icon.jpeg',
                              width: 70,
                              height: 35,
                              fit: BoxFit.cover,
                            ),
                          )
                      ],
                    ),
                  ),



                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),

          /// DADOS
          _info(
            Icons.badge_outlined,
            Formatadores.formatarCnpj(emp.cnpj ?? ''),
          ),

          _info(Icons.sell_outlined, emp.cnaDescricao),

          _info(Icons.numbers, emp.cna?.toString()),

          _info(Icons.fingerprint, emp.id),

          const SizedBox(height: 12),


        ],
      ),
    );
  }
}