import 'package:flutter/material.dart';

class NovaEmpresaDialog extends StatefulWidget {
  const NovaEmpresaDialog({super.key});

  @override
  State<NovaEmpresaDialog> createState() => _NovaEmpresaDialogState();
}

class _NovaEmpresaDialogState extends State<NovaEmpresaDialog> {
  final cnpj = TextEditingController();
  final cnae = TextEditingController();
  final atividade = TextEditingController();
  final razaoSocial = TextEditingController();
  final nomeFantasia = TextEditingController();
  final telefone = TextEditingController();
  final email = TextEditingController();
  final endereco = TextEditingController();

  final Map<String, bool> socios = {
    "Carlos Eduardo Mendes": false,
    "Ana Paula Ferreira": false,
    "Roberto Silva Costa": false,
  };

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 720,
        height: 650,
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Nova Empresa",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            /// BODY SCROLL
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    /// CNPJ + CNAE
                    Row(
                      children: [
                        Expanded(
                          child: _campo("CNPJ *",
                              "00.000.000/0000-00", cnpj),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _campo("CNAE *", "0000-0/00", cnae),
                        ),
                      ],
                    ),

                    _campo(
                      "Atividade Econômica (CNAE) *",
                      "Ex: Desenvolvimento de programas de computador",
                      atividade,
                    ),

                    _campo(
                      "Razão Social *",
                      "Ex: Silva & Souza Comércio Ltda",
                      razaoSocial,
                    ),

                    _campo(
                      "Nome Fantasia",
                      "Ex: SS Comércio",
                      nomeFantasia,
                    ),

                    /// TELEFONE + EMAIL
                    Row(
                      children: [
                        Expanded(
                          child: _campo(
                              "Telefone", "(00) 00000-0000", telefone),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child:
                          _campo("E-mail", "contato@empresa.com", email),
                        ),
                      ],
                    ),

                    _campo(
                      "Endereço",
                      "Rua, número — Cidade/UF",
                      endereco,
                    ),

                    const SizedBox(height: 10),

                    /// SÓCIOS
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Sócios Vinculados",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Column(
                      children: socios.keys.map((nome) {
                        return CheckboxListTile(
                          value: socios[nome],
                          onChanged: (v) {
                            setState(() {
                              socios[nome] = v ?? false;
                            });
                          },
                          title: Text(nome),
                          controlAffinity:
                          ListTileControlAffinity.leading,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            /// FOOTER
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancelar"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF123C3C),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cadastrar Empresa"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// CAMPO PADRÃO
  Widget _campo(
      String label, String hint, TextEditingController controller) {
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