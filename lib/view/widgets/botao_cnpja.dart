import 'package:cnpjjaUi/repositorio/api_service.dart';
import 'package:flutter/material.dart';

import '../../helprs/cores.dart';
import '../../model/empresas_conciliadora.dart';

class BotaoCnpjJa extends StatefulWidget {
  final EmpresasConciliadora empresasConciliadora;

  const BotaoCnpjJa({super.key, required this.empresasConciliadora});

  @override
  State<BotaoCnpjJa> createState() => _BotaoCnpjJaState();
}

class _BotaoCnpjJaState extends State<BotaoCnpjJa> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Clique para pesquisar no CNPJ Já",
      child: MouseRegion(
        onEnter: (_) => setState(() => hover = true),
        onExit: (_) => setState(() => hover = false),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () async {
            final resultado = await ApiService.pesquisarCnpjja(
              widget.empresasConciliadora.cnpj!,
            );

            if (resultado == 200) {
              final status = await ApiService.atualizarStatusEmpresa(
                widget.empresasConciliadora.id,
              );
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.bounceInOut,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Cores.verde_cnpjja,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              'assets/img/cnpja.png',
              width: hover ? 70 : 40,
              height: 22,
            ),
          ),
        ),
      ),
    );
  }
}
