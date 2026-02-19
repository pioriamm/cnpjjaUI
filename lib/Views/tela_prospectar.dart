import 'package:flutter/material.dart';
import 'package:proj_flutter/Views/tela_consultaCnpjPage.dart';
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

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF2F7),
      body: Row(
        children: [
          /// ================= SIDEBAR =================
          Container(
            width: 230,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffEAF1FF), Color(0xffDCE8FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const ListTile(
                  leading: Icon(Icons.work),
                  title: Text("Prospectar\nEmpresas", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(),
                GestureDetector(
                  child: const ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Início"),
                  ),
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const TelaProspectar()),
                        (route) => false,
                  ),
                ),

                GestureDetector(
                  child: ListTile(leading: Icon(Icons.storage), title: Text("Popular Base")),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TelaConsultaCnpjPage
                    (cnpjs: BaseConciliadora.Lista_base_conciliadora,))),
                ),
                const ListTile(leading: Icon(Icons.star_border), title: Text("Favoritos")),
                const ListTile(leading: Icon(Icons.chat_bubble_outline), title: Text("Contato")),
                const Spacer(),
                const ListTile(leading: Icon(Icons.settings), title: Text("Configurações")),
                const SizedBox(height: 20),
              ],
            ),
          ),

          /// ================= CONTEÚDO =================
          Expanded(
            child: Column(
              children: [
                _topBar(),

                Expanded(
                  child: FutureBuilder<List<Prospectar>>(
                    future: _futureDados,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final lista = snapshot.data!;

                      return ListView(
                        padding: const EdgeInsets.all(24),
                        children: lista.expand((prospectar) {
                          final dadosFiltrados = (prospectar.dados ?? [])
                              .where((dado) => _filtroCnpj.isEmpty || (dado.cnpjRaizId ?? '').contains(_filtroCnpj))
                              .toList();

                          return dadosFiltrados.map((dado) => _cardEmpresa(dado)).toList();
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= TOP BAR =================

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Pesquisar por CNPJ, Nome ou Telefone",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xffF4F6FA),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => _filtroCnpj = v),
            ),
          ),
          const SizedBox(width: 20),
          const CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }

  // ================= CARD EMPRESA =================

  Widget _cardEmpresa(dado) {
    final isBase = (BaseConciliadora.Lista_base_conciliadora ?? []).contains(dado.cnpjRaizId);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12, offset: Offset(0, 4))],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(20),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.business_center),
        ),
        title: Text(dado.empresaRaiz ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text("CNPJ: ${dado.cnpjRaizId}"),
        trailing: isBase
            ? const Text(
                "Base de Conciliadora",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              )
            : const Icon(Icons.favorite_border, color: Colors.orange),
        children: [_detalhesEmpresa(dado)],
      ),
    );
  }

  // ================= DETALHES =================

  Widget _detalhesEmpresa(dado) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Status: ${dado.status?.text ?? ''}", style: const TextStyle(color: Colors.green)),

        const SizedBox(height: 15),

        /// TELEFONES
        ...(dado.telefone ?? []).map((t) => Text("(${t.area}) ${t.number}")),

        const SizedBox(height: 10),

        /// EMAILS
        ...(dado.email ?? []).map((e) => Text(e.address ?? "")),

        const SizedBox(height: 20),

        _socios(dado),

        const SizedBox(height: 20),
      ],
    );
  }

  // ================= SOCIOS =================

  Widget _socios(dado) {
    return ExpansionTile(
      title: Text("Sócios da empresa ${dado.empresaRaiz}", style: const TextStyle(fontWeight: FontWeight.bold)),
      children: (dado.membros ?? []).map<Widget>((membro) {
        final empresas = membro.empresas ?? [];

        return ExpansionTile(
          leading: const Icon(Icons.person_outline),
          title: Text("${membro.nomeMembro}"),
          children: [
            if (empresas.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Outras empresas que possui participação",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                  ),
                  ...empresas.map((emp) {
                    final iguais = (emp.nomeEmpresaSocio ?? '').toLowerCase() == (dado.empresaRaiz ?? '').toLowerCase();

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: iguais ? Colors.red.shade50 : Colors.green.shade100,
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.location_on_outlined),
                        title: Text(
                          emp.nomeEmpresaSocio ?? '',
                          style: TextStyle(
                            color: iguais ? Colors.redAccent : Colors.green,
                            fontWeight: iguais ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        trailing: Text(iguais ? "👎🏻" : "👍🏻", style: TextStyle(fontSize: 30)),
                      ),
                    );
                  }),
                ],
              ),
          ],
        );
      }).toList(),
    );
  }
}
