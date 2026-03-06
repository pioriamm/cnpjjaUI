import 'package:cnpjjaUi/helprs/cores.dart';
import 'package:cnpjjaUi/helprs/formatadores.dart';
import 'package:cnpjjaUi/model/enum_menu_item.dart';
import 'package:cnpjjaUi/view/widgets/empresa_card_widget.dart';
import 'package:cnpjjaUi/view/widgets/filtro_busca_widget.dart';
import 'package:cnpjjaUi/view/widgets/side_bar_widget.dart';
import 'package:cnpjjaUi/view/widgets/titulo_contador.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modelview/buscar_base_cnpja_provider.dart';

class TelaEmpresas extends StatefulWidget {
  const TelaEmpresas({super.key});

  @override
  State<TelaEmpresas> createState() => _TelaEmpresasState();
}

class _TelaEmpresasState extends State<TelaEmpresas> {

  final TextEditingController _filtroController = TextEditingController();

  MenuItem _selected = MenuItem.empresas;

  String filtro = '';
  String filtroStatus = 'TODAS';

  static const int paginasPorBloco = 25;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<BuscarBaseCnpjaProvider>().buscarPagina(0);
    });
  }

  @override
  void dispose() {
    _filtroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final tela = MediaQuery.of(context).size;

    return SelectionArea(
      child: Scaffold(
        body: Row(
          children: [

            SizedBox(
              width: tela.width * 0.2,
              child: SideBarWidget(
                selectedItem: _selected,
                onItemSelected: (item) {
                  setState(() => _selected = item);
                },
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: tela.width * 0.09,
                  vertical: 50,
                ),

                child: Consumer<BuscarBaseCnpjaProvider>(
                  builder: (_, provider, __) {

                    final lista = provider.listaProspecao;

                    final empresasFiltradas = lista.where((empresa) {

                      final dados = (empresa.dados != null && empresa.dados!.isNotEmpty)
                          ? empresa.dados!.first
                          : null;

                      final filtroLower = filtro.toLowerCase();
                      final status = dados?.status?.text ?? '';

                      final matchTexto =
                          (dados?.empresaRaiz ?? '').toLowerCase().contains(filtroLower) ||
                              (dados?.alias ?? '').toLowerCase().contains(filtroLower) ||
                              (dados?.cnpjRaizId ?? '').contains(filtro);

                      bool matchStatus = true;

                      if (filtroStatus == 'ATIVAS') {
                        matchStatus = status == 'Ativa';
                      }

                      if (filtroStatus == 'INATIVAS') {
                        matchStatus = status != 'Ativa';
                      }

                      return matchTexto && matchStatus;

                    }).toList();

                    int start = provider.paginaAtual - (paginasPorBloco ~/ 2);

                    if (start < 0) start = 0;

                    if (start > provider.totalPaginas - paginasPorBloco) {
                      start = provider.totalPaginas - paginasPorBloco;
                    }

                    int end = start + paginasPorBloco;

                    if (end > provider.totalPaginas) {
                      end = provider.totalPaginas;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Empresas da Base Conciliadora",
                          style: TextStyle(
                            fontSize: 30,
                            color: Cores.verde_escuro,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TituloContador(
                          lista: provider.listaProspecao.length,
                          titulo: ' empresas carregadas.',
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [

                            Expanded(
                              child: FiltroBuscaWidget(
                                controller: _filtroController,
                                hintText: 'Filtrar por razão social, CNPJ...',
                                onChanged: (valor) {
                                  setState(() {
                                    filtro = valor;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(width: 15),

                            SizedBox(
                              width: 160,
                              height: 50,
                              child: DropdownButtonFormField<String>(
                                value: filtroStatus,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 'TODAS', child: Text("Todos")),
                                  DropdownMenuItem(value: 'ATIVAS', child: Text("Ativas")),
                                  DropdownMenuItem(value: 'INATIVAS', child: Text("Inativas")),
                                ],
                                onChanged: (valor) {
                                  setState(() {
                                    filtroStatus = valor!;
                                  });
                                },
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [

                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: provider.paginaAtual > 0
                                  ? () => provider.buscarPagina(provider.paginaAtual - 1)
                                  : null,
                            ),

                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: end - start,
                                  itemBuilder: (context, index) {

                                    final pagina = start + index;
                                    final selecionada = pagina == provider.paginaAtual;

                                    return InkWell(
                                      onTap: () => provider.buscarPagina(pagina),
                                      child: Container(
                                        width: 40,
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: selecionada
                                              ? Cores.verde_claro
                                              : Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          "${pagina + 1}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: selecionada
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: provider.paginaAtual < provider.totalPaginas - 1
                                  ? () => provider.buscarPagina(provider.paginaAtual + 1)
                                  : null,
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        if (provider.isLoading && lista.isEmpty)
                          const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )

                        else if (provider.erro != null)
                          Expanded(
                            child: Center(
                              child: Text("Erro: ${provider.erro}"),
                            ),
                          )

                        else if (empresasFiltradas.isEmpty)
                            const Expanded(
                              child: Center(
                                child: Text("Nenhuma empresa encontrada"),
                              ),
                            )

                          else
                            Expanded(
                              child: ListView.builder(
                                itemCount: empresasFiltradas.length,
                                itemBuilder: (context, index) {

                                  final wrapper = empresasFiltradas[index];

                                  final empresaAtual =
                                  (wrapper.dados != null && wrapper.dados!.isNotEmpty)
                                      ? wrapper.dados!.first
                                      : null;

                                  final razaoSocial = empresaAtual?.empresaRaiz ?? 'Não informado';
                                  final nomeFantasia = empresaAtual?.alias ?? 'Não informado';

                                  final cnpj = empresaAtual?.cnpjRaizId != null
                                      ? Formatadores.formatarCnpj(empresaAtual!.cnpjRaizId!)
                                      : 'Não informado';

                                  final cnae = empresaAtual?.cnae?.id != null
                                      ? Formatadores.formatarCnae("${empresaAtual!.cnae!.id}")
                                      : 'Não informado';

                                  final atividade = empresaAtual?.cnae?.descricao ?? 'Não informado';

                                  final telefone = (empresaAtual?.telefone ?? [])
                                      .map<String>((tel) =>
                                  "(${tel.area ?? ''}) ${tel.number ?? ''}")
                                      .join(' • ');

                                  final email = (empresaAtual?.email ?? []).isNotEmpty
                                      ? empresaAtual!.email!.first.address ?? 'Não informado'
                                      : 'Não informado';

                                  final socios = (empresaAtual?.membros ?? [])
                                      .map((m) => m.nomeMembro ?? 'Não informado')
                                      .toList();

                                  return EmpresaCardWidget(
                                    ativoConciliadora: empresaAtual?.ativoConciliadora ?? false,
                                    razaoSocial: razaoSocial,
                                    nomeFantasia: nomeFantasia,
                                    cnpj: cnpj,
                                    cnae: cnae,
                                    atividade: atividade,
                                    telefone: telefone.isEmpty ? 'Não informado' : telefone,
                                    email: email,
                                    socios: socios,
                                    empresasVinculadas: empresaAtual?.membros ?? [],
                                    conciliadora: empresaAtual?.eConciliadora ?? false,
                                  );
                                },
                              ),
                            ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}