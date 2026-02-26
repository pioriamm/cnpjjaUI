import 'package:cnpjjaUi/helprs/cores.dart';
import 'package:cnpjjaUi/view/widgets/tag.dart';
import 'package:flutter/material.dart';
import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:provider/provider.dart';
import '../../modelview/atualizar_status_base_provider.dart';

class EmpresaCardNovoWidget extends StatelessWidget {
  final String cnpj;
  final String id;
  final String razaoSocial;
  final String alias;
  final String cnae;
  final String cnaDescricao;
  final bool pesquisado;
  final bool conciliadora;

  const EmpresaCardNovoWidget({
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
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.business),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      razaoSocial,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      alias,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),

              Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
            ],
          ),

          const SizedBox(height: 12),

          /// TAGS
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Tag(
                child: Text(
                  Formatadores.formatarCnpj(cnpj),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ),

              if (cnae.isNotEmpty)
                Tag(
                  child: Text(cnae, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                ),

              if (conciliadora)
                Tag(
                  cor: Cores.verde_claro,
                  child: const Text("Conciliadora", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
                ),

              pesquisado
                  ? Tag(
                      cor: Cores.verde_claro,
                      child: const Text("Pesquisado", overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12)),
                    )
                  : Consumer<PesquisaAtualizarBaseStatusProvider>(
                      builder: (_, provider, __) {
                        return Tag(
                          chamar: provider.isLoading(id)
                              ? null
                              : () {
                                  context.read<PesquisaAtualizarBaseStatusProvider>().pesquisarEmpresa(
                                    context: context,
                                    cnpj: cnpj,
                                    id: id,
                                    razaoSocial: razaoSocial,
                                  );
                                },
                          child: provider.isLoading(id)
                              ? const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text("Pesquisar", style: TextStyle(fontSize: 12)),
                        );
                      },
                    ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            cnaDescricao.isEmpty ? "-" : cnaDescricao,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
