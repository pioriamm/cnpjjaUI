import 'package:flutter/material.dart';
import 'package:proj_flutter/helprs/Cores.dart';

import '../botao_padrao.dart';

class NovoSocioDialog extends StatefulWidget {
  const NovoSocioDialog({super.key});

  @override
  State<NovoSocioDialog> createState() => _NovoSocioDialogState();
}

class _NovoSocioDialogState extends State<NovoSocioDialog> {
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Novo Sócio",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 16),

            _campo("Nome Completo *", "Ex: João da Silva", nomeController),
            _campo("CPF *", "000.000.000-00", cpfController),
            _campo("E-mail", "joao@email.com", emailController),
            _campo("Telefone", "(00) 00000-0000", telefoneController),

            const SizedBox(height: 24),

            /// BOTÕES
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                BotaoPadrao(acao: ()=>Navigator.pop(context), cor: Cores.branco, conteudo: [Text("Cancelar",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Cores.verde_escuro),)
                ],),
                const SizedBox(width: 12),
                BotaoPadrao(acao: () {
                  final dados = {
                    "nome": nomeController.text,
                    "cpf": cpfController.text,
                    "email": emailController.text,
                    "telefone": telefoneController.text,
                  };

                  Navigator.pop(context, dados);
                }, cor: Cores.verde_escuro, conteudo: [Text("Cadastrar "
                    "sócio", style: TextStyle(color: Cores.branco, fontWeight: FontWeight.bold),)
                ],),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _campo(
      String label,
      String hint,
      TextEditingController controller,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}