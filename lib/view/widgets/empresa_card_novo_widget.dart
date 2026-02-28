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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.business),
              ),

              const SizedBox(width: 20, ),

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
                    SizedBox(height: 10),
                    Tag(
                      child: Text(
                        Formatadores.formatarCnpj(cnpj),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (cnae.isNotEmpty)
                      Tag(
                        child: Text(
                          Formatadores.formatarCnae(cnae),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),

                    Text(cnaDescricao.isEmpty ? "-" : cnaDescricao),
                  ],
                ),
              ),

              pesquisado
                  ? Icon(Icons.search_rounded, color: Cores.cinza)
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

          if (conciliadora)
            SizedBox(height: 20,),
            Tag(
              cor: Colors.grey.shade300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  razaoSocial.length < 50
                  ? Text("A empresa ${razaoSocial}, já se enconta na basd da Conciliadora",overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12,color: Cores.verde_escuro, fontWeight: FontWeight.normal),)
                  : Text("A empresa ${razaoSocial.substring(0,50)}..., já se enconta na basd da Conciliadora",
                    overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12,color: Cores.verde_escuro, fontWeight: FontWeight.normal),),
                  SizedBox(width: 10,),
                  Icon(Icons.verified, color: Cores.verde_claro),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
