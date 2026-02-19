import 'package:flutter/material.dart';
import '../Models/baseConciliadora.dart';
import '../ModerViews/buscarApi.dart';
import '../models/prospectar.dart';

class TelaProspectar extends StatefulWidget {
  const TelaProspectar({super.key});

  @override
  State<TelaProspectar> createState() => _TelaProspectarState();
}

class _TelaProspectarState extends State<TelaProspectar> {
  late Future<List<Prospectar>> _futureDados;

  final TextEditingController _searchController = TextEditingController();
  String _filtroCnpj = '';

  @override
  void initState() {
    super.initState();
    _futureDados = BuscarApi.buscarDadosApi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Empresas')),
      body: Column(
        children: [
          // 🔎 Campo de pesquisa
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Pesquisar por CNPJ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _filtroCnpj = value;
                });
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<Prospectar>>(
              future: _futureDados,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar dados'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum dado encontrado'));
                }

                final lista = snapshot.data!;

                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final prospectar = lista[index];

                    final dadosFiltrados = (prospectar.dados ?? [])
                        .where((dado) => _filtroCnpj.isEmpty || (dado.cnpjRaizId ?? '').contains(_filtroCnpj))
                        .toList();

                    if (dadosFiltrados.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: dadosFiltrados.map((dado) {
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if ((BaseConciliadora.Lista_base_conciliadora ?? []).contains(dado.cnpjRaizId)) ...[
                                  Row(
                                    children: [
                                      Expanded(child: Text("Razão Social: ${dado.empresaRaiz ?? ''}")),
                                      const SizedBox(width: 8),
                                      const Text("Base da Conciliadora", style: TextStyle(color: Colors.green)),
                                    ],
                                  ),
                                ] else ...[
                                  Text("Razão Social: ${dado.empresaRaiz ?? ''}"),
                                ],
                                Text("CNPJ: ${dado.cnpjRaizId ?? ''}"),
                                Text("Status: ${dado.status?.text ?? ''}"),

                                const SizedBox(height: 20),

                                // TELEFONES
                                if ((dado.telefone ?? []).isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  const Text("Telefones:", style: TextStyle(fontWeight: FontWeight.bold)),

                                  const SizedBox(height: 4),

                                  ...(dado.telefone ?? []).map(
                                    (t) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: Text("(${t.area}) ${t.number}"),
                                    ),
                                  ),
                                ],

                                // EMAILS
                                if ((dado.email ?? []).isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  const Text("Emails:", style: TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 4),
                                  ...(dado.email ?? []).map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: Text(e.address ?? ''),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 20),

                                // MEMBROS
                                if ((dado.membros ?? []).isNotEmpty)
                                  ExpansionTile(
                                    tilePadding: EdgeInsets.zero,
                                    title: Text("Socios da empresa ${dado.empresaRaiz}"),
                                    children: (dado.membros ?? []).map((membro) {
                                      final empresas = membro.empresas ?? [];

                                      return ExpansionTile(
                                        title: Text("Membro: ${membro.nomeMembro}" ?? ''),
                                        children: empresas.isNotEmpty
                                            ? empresas.map((emp) {
                                                final membrosSocio = emp.membrosEmpresaSocio ?? [];

                                                return ExpansionTile(
                                                  title: Builder(
                                                    builder: (_) {
                                                      final nomeEmpresaSocio = (emp.nomeEmpresaSocio ?? '')
                                                          .toLowerCase()
                                                          .trim();
                                                      final nomeEmpresaPrincipal = (dado.empresaRaiz ?? '')
                                                          .toLowerCase()
                                                          .trim();

                                                      final iguais = nomeEmpresaSocio == nomeEmpresaPrincipal;

                                                      return Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              emp.nomeEmpresaSocio ?? '',
                                                              style: TextStyle(
                                                                color: iguais ? Colors.red : Colors.black,
                                                                fontWeight: iguais
                                                                    ? FontWeight.bold
                                                                    : FontWeight.normal,
                                                              ),
                                                            ),
                                                          ),
                                                          Text(iguais ? "👎🏻" : "👍🏻"),
                                                        ],
                                                      );
                                                    },
                                                  ),

                                                  children: membrosSocio.map((p) {
                                                    final nomePessoa = (p.name ?? '').toLowerCase().trim();
                                                    final nomeEmpresa = (dado.empresaRaiz ?? '').toLowerCase().trim();

                                                    final iguais = nomePessoa == nomeEmpresa;

                                                    return ListTile(
                                                      title: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "${p.name ?? ''} (${p.age ?? ''})",
                                                              style: TextStyle(
                                                                color: iguais ? Colors.red : Colors.black,
                                                                fontWeight: iguais
                                                                    ? FontWeight.bold
                                                                    : FontWeight.normal,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              }).toList()
                                            : const [ListTile(title: Text("Sem empresas vinculadas"))],
                                      );
                                    }).toList(),
                                  ),

                                // EMPRESAS SÓCIO
                                if ((dado.empresas ?? []).isNotEmpty)
                                  ExpansionTile(
                                    title: const Text("Empresas Sócio"),
                                    children: (dado.empresas ?? []).map((empresa) {
                                      final membrosSocio = empresa.membrosEmpresaSocio ?? [];

                                      final estaNaConciliadora = (BaseConciliadora.Lista_base_conciliadora ?? [])
                                          .contains(empresa.idEmpresaSocio);

                                      return ExpansionTile(
                                        title: Row(
                                          children: [
                                            Expanded(child: Text("Socios: ${empresa.nomeEmpresaSocio}" ?? '')),
                                          ],
                                        ),
                                        children: membrosSocio
                                            .map((p) => ListTile(title: Text("${p.name ?? ''} (${p.age ?? ''})")))
                                            .toList(),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
