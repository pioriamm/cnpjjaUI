import 'package:flutter/material.dart';
import 'package:proj_flutter/Views/tela_antiga/tela_consultaCnpjPage.dart';
import 'package:proj_flutter/helprs/formatadores.dart';
import '../../helprs/baseConciliadora.dart';
import '../../ModerViews/buscarApiMongo.dart';
import '../../models/prospectar.dart';
import '../widgets/BotaoFavorito.dart';
import '../widgets/SidebarItem.dart';

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
    _futureDados = BuscarApiMongo.buscarDadosMongo();
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
          _sideBar(),
          Expanded(
            child: Column(
              children: [
                _topBar(),
                Expanded(child: _listaEmpresas()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SIDEBAR =================

  Widget _sideBar() {
    return Container(
      width: 230,
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xffEAF1FF), Color(0xffDCE8FF)])),
      child: Column(
        children: [
          const SizedBox(height: 40),

          const ListTile(
            leading: Icon(Icons.work),
            title: Text("Prospectar\nEmpresas", style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          const Divider(),

          SidebarItem(
            icon: Icons.home,
            title: "Início",
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 350),
                pageBuilder: (_, animation, __) => const TelaProspectar(),
                transitionsBuilder: (_, animation, __, child) {
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0.08, 0),
                    end: Offset.zero,
                  ).animate(animation);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slideAnimation, child: child),
                  );
                },
              ),
              (route) => false,
            ),
          ),

          SidebarItem(
            icon: Icons.storage,
            title: "Popular Base",
            onTap: () => Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 350),
                pageBuilder: (_, animation, __) =>
                    TelaConsultaCnpjPage(cnpjs: BaseConciliadora.Lista_base_conciliadora),
                transitionsBuilder: (_, animation, __, child) {
                  final slide = Tween(begin: const Offset(0.1, 0), end: Offset.zero).animate(animation);

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slide, child: child),
                  );
                },
              ),
            ),
          ),

          const SidebarItem(icon: Icons.star_border, title: "Favoritos"),

          const SidebarItem(icon: Icons.chat_bubble_outline, title: "Contato"),

          const Spacer(),

          const SidebarItem(icon: Icons.settings, title: "Configurações"),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= TOPBAR =================

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

  // ================= LISTA =================

  Widget _listaEmpresas() {
    return FutureBuilder<List<Prospectar>>(
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
        subtitle: Text("CNPJ: ${Formatadores.formatarCnpj(dado.cnpjRaizId)}"),
        trailing: isBase ? const BotaoFavorito() : const Icon(Icons.favorite_border, color: Colors.orange),
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

        ...(dado.telefone ?? []).map((t) => Text("(${t.area}) ${t.number}")),

        const SizedBox(height: 10),

        ...(dado.email ?? []).map((e) => Text(e.address ?? "")),

        const SizedBox(height: 20),

        _socios(dado),

        const SizedBox(height: 20),
      ],
    );
  }

  // ================= SOCIOS (FILTRADO CORRETAMENTE) =================

  Widget _socios(dado) {
    final empresaRaiz = (dado.empresaRaiz ?? '').toLowerCase().trim();

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      title: Text("Sócios da empresa ${dado.empresaRaiz}", style: const TextStyle(fontWeight: FontWeight.bold)),
      children: (dado.membros ?? []).map<Widget>((membro) {
        /// remove empresa raiz + somente ATIVAS
        final empresasAtivas = (membro.empresas ?? [])
            .where(
              (emp) => (emp.nomeEmpresaSocio ?? '').toLowerCase().trim() != empresaRaiz && emp.status?.text == "Ativa",
            )
            .toList();

        if (empresasAtivas.isEmpty) {
          return ExpansionTile(
            enabled: false,
            leading: const Icon(Icons.person_outline),
            title: Text(membro.nomeMembro ?? ""),
            children: const [ListTile(title: Text("Sem empresas ativas vinculadas"))],
          );
        }

        return ExpansionTile(
          leading: const Icon(Icons.person_outline),
          title: Text(membro.nomeMembro ?? ""),
          children: empresasAtivas.map<Widget>((emp) {
            final membrosSocio = emp.membrosEmpresaSocio ?? [];
            final telefones = emp.telefone ?? [];
            final emails = emp.email ?? [];

            return ExpansionTile(
              title: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xffF4F6FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// ICONE
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xffE8D1A7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.business_center,
                        color: Colors.deepPurple,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// CONTEUDO
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// NOME EMPRESA
                          Text(
                            emp.nomeEmpresaSocio ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 4),

                          /// CNPJ
                          if (emp.cnpjEmpresaSocio != null)
                            Text(
                              "CNPJ: ${Formatadores.formatarCnpj(emp.cnpjEmpresaSocio)}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),

                          const SizedBox(height: 14),

                          /// STATUS
                          Text(
                            "Status: ${emp.status?.text ?? ''}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// TELEFONES
                          if (telefones.isNotEmpty)
                            ...telefones.map<Widget>(
                                  (t) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  "(${t.area}) ${t.number}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),

                          /// EMAILS
                          if (emails.isNotEmpty)
                            ...emails.map<Widget>(
                                  (e) => Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  e.address ?? "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                if (membrosSocio.isNotEmpty)
                  ...membrosSocio.map<Widget>(
                    (p) => ListTile(leading: const Icon(Icons.person), title: Text("${p.name ?? ''} (${p.age ?? ''})")),
                  )
                else
                  const ListTile(title: Text("Sem sócios cadastrados")),
              ],
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
