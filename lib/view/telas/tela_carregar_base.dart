import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';
import 'package:cnpjjaUi/view/widgets/titulo_contador.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/enum_menu_item.dart';
import 'package:cnpjjaUi/helprs/cores.dart';
import '../../modelview/busca_base_conciliadora_provider.dart';
import '../widgets/empresa_card_novo_widget.dart';

class TelaCarregarBase extends StatefulWidget {
  const TelaCarregarBase({super.key});

  @override
  State<TelaCarregarBase> createState() => _TelaCarregarBaseState();
}

class _TelaCarregarBaseState extends State<TelaCarregarBase> {
  MenuItem _selected = MenuItem.pesquisarBase;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<BuscarBaseConciliadoraProvider>().carregarBase(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tela = MediaQuery.of(context).size;

    return SelectionArea(

      child: Scaffold(
        body: Row(
          children: [
            /// SIDEBAR
            SizedBox(
              width: tela.width * 0.2,
              child: SideBarWidget(
                selectedItem: _selected,
                onItemSelected: (item) {
                  setState(() => _selected = item);
                },
              ),
            ),
      
            /// CONTEÚDO
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tela.width * 0.09, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        Text(
                          "Carregar Base",
                          style: TextStyle(fontSize: 30, color: Cores.verde_escuro, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
      
                    const SizedBox(height: 8),
      
                    /// CONTADOR AUTOMÁTICO
                    Consumer<BuscarBaseConciliadoraProvider>(
                      builder: (_, provider, __) => TituloContador(lista: provider.quantidadePendentes,
                        titulo: ' Empresas Pendentes de Pesquisa.',)
                    ),
      
                    const SizedBox(height: 15),
      
                    /// LISTA CONTROLADA PELO PROVIDER
                    Expanded(
                      child: Consumer<BuscarBaseConciliadoraProvider>(
                        builder: (_, provider, __) {
                          /// ERRO
                          if (provider.erro != null) {
                            return Center(child: Text("Erro: ${provider.erro}"));
                          }
      
                          /// LOADING
                          if (provider.isLoading) {
                            return const Center(child: CircularProgressIndicator());
                          }
      
                          /// VAZIO
                          if (provider.listaAtualizada.isEmpty) {
                            return const Center(child: Text("Nenhuma empresa encontrada"));
                          }
      
                          /// LISTA
                          return ListView.builder(
                            itemCount: provider.listaAtualizada.length,
                            itemBuilder: (context, index) {
                              final empresa = provider.listaAtualizada[index];
      
                              return EmpresaCardNovoWidget(
                                cnpj: empresa.cnpj ?? "",
                                razaoSocial: empresa.razaoSocial ?? "",
                                alias: empresa.alias ?? "",
                                cnae: empresa.cna ?? "",
                                cnaDescricao: empresa.cnaDescricao ?? "",
                                pesquisado: empresa.pesquisado ?? false,
                                conciliadora: empresa.conciliadora ?? false,
                                id: empresa.id ?? "",
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
