import 'package:cnpjjaUi/helprs/Cores.dart';
import 'package:flutter/material.dart';
import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:go_router/go_router.dart';
import '../modelview/buscarApiMongo.dart';

class EmpresaCardWidget extends StatelessWidget {
  final String cnpj;
  final String id;
  final String razaoSocial;
  final String alias;
  final String cnae;
  final String cnaDescricao;
  final bool pesquisado;
  final bool conciliadora;

  const EmpresaCardWidget({
    super.key,
    required this.cnpj,
    required this.razaoSocial,
    required this.alias,
    required this.cnae,
    required this.cnaDescricao,
    required this.pesquisado,
    required this.conciliadora,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(16),
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
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.business),
              ),
              const SizedBox(width: 12),

              /// evita overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      razaoSocial,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alias,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.keyboard_arrow_down,
                  color: Colors.grey.shade600),
            ],
          ),

          const SizedBox(height: 12),

          /// TAGS
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _tag(Formatadores.formatarCnpj(cnpj)),

              if (cnae.isNotEmpty) _tag(cnae),

              if (conciliadora) _tag("Conciliadora", cor: Cores.verde_claro),

              pesquisado
                  ? _tag("Pesquisado", cor: Cores.verde_claro)
                  : _tag("Pesquisar", chamar: () => _pesquisarEmpresa(context),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// DESCRIÇÃO
          Text(
            cnaDescricao.isEmpty ? "-" : cnaDescricao,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// AÇÃO DE PESQUISA (CORRIGIDA)
  /// ===============================
  Future<void> _pesquisarEmpresa(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    try {
      messenger.showSnackBar(
        SnackBar(
          content: Text("Iniciando a Pesquisa: $razaoSocial"),
          backgroundColor: Cores.verde_claro,
        ),
      );

      print("Chamando API...");
      final result = await BuscarApiMongo.pesquisarCnpjja(cnpj);
      print("Resultado API: $result");

      if (!context.mounted) return;

      messenger.hideCurrentSnackBar();

      if (result == 200) {
        await BuscarApiMongo.atualizarStatusEmpresa(id);

        messenger.showSnackBar(
          const SnackBar(
            content: Text("Empresa pesquisada com sucesso, atualiza a sua tela"),
            backgroundColor: Colors.amber,
          ),
        );

        context.go('/carregar-base');
      }
    } catch (e, s) {
      print(e);
      print(s);

      if (!context.mounted) return;

      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Erro: $e"),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  /// TAG reutilizável
  Widget _tag(String text, {VoidCallback? chamar, Color? cor}) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cor ?? Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
    );

    if (chamar == null) return child;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: chamar,
      child: child,
    );
  }
}