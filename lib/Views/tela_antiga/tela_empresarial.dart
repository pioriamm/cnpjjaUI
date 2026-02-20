import 'package:flutter/material.dart';
import 'package:proj_flutter/Models/prospectar.dart';
import 'package:proj_flutter/ModerViews/buscarApiMongo.dart';
import 'package:proj_flutter/Views/widgets/BotaoFavorito.dart';
import 'package:proj_flutter/helprs/baseConciliadora.dart';
import 'package:proj_flutter/helprs/formatadores.dart';

import '../widgets/SidebarItem.dart';

class TelaEmpresarial extends StatefulWidget {
  const TelaEmpresarial({super.key});

  @override
  State<TelaEmpresarial> createState() => _TelaEmpresarialState();
}

class _TelaEmpresarialState extends State<TelaEmpresarial> {
  late Future<List<Prospectar>> _futureDados;

  final TextEditingController _searchController = TextEditingController();

  String _filtroCnpj = '';
  dynamic _membroSelecionado;

  @override
  void initState() {
    super.initState();
    //_futureDados = BuscarApiMongo.buscarDadosMongo();
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffEAF1FF), Color(0xffDCE8FF)],
        ),
      ),
      child: Column(
        children: const [
          SizedBox(height: 40),
          ListTile(
            leading: Icon(Icons.work),
            title: Text(
              "Prospectar\nEmpresas",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          SidebarItem(icon: Icons.home, title: "Início"),
          SidebarItem(icon: Icons.storage, title: "Popular Base"),
          SidebarItem(icon: Icons.star_border, title: "Favoritos"),
          SidebarItem(icon: Icons.chat_bubble_outline, title: "Contato"),
          Spacer(),
          SidebarItem(icon: Icons.settings, title: "Configurações"),
          SizedBox(height: 20),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
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
                .where((dado) =>
            _filtroCnpj.isEmpty ||
                (dado.cnpjRaizId ?? '').contains(_filtroCnpj))
                .toList();

            return dadosFiltrados.map(_cardEmpresa).toList();
          }).toList(),
        );
      },
    );
  }

  // ================= CARD EMPRESA =================

  Widget _cardEmpresa(dado) {
    final isBase =
    (BaseConciliadora.Lista_base_conciliadora ?? [])
        .contains(dado.cnpjRaizId);

    final membros = dado.membros ?? [];

    if (membros.isNotEmpty && _membroSelecionado == null) {
      _membroSelecionado = membros.first;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              blurRadius: 14,
              color: Colors.black12,
              offset: Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// HEADER
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.business_center),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dado.empresaRaiz ?? '',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "CNPJ: ${Formatadores.formatarCnpj(dado.cnpjRaizId)}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),

              isBase
                  ? const BotaoFavorito()
                  : const Icon(Icons.favorite_border,
                  color: Colors.orange),
            ],
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 30,
            children: [
              Text(
                "Status: ${dado.status?.text ?? ''}",
                style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600),
              ),
              ...(dado.telefone ?? [])
                  .map((t) => Text("(${t.area}) ${t.number}")),
              ...(dado.email ?? [])
                  .map((e) => Text(e.address ?? "")),
            ],
          ),

          const SizedBox(height: 24),

          if (membros.isNotEmpty)
            SizedBox(
              height: 320,
              child: Row(
                children: [

                  /// ================= SOCIOS =================
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xffF4F6FA),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListView.builder(
                        itemCount: membros.length,
                        itemBuilder: (_, i) {
                          final membro = membros[i];

                          final selecionado =
                              membro == _membroSelecionado;

                          return ListTile(
                            selected: selecionado,
                            selectedTileColor:
                            Colors.deepPurple.withOpacity(.08),
                            leading:
                            const Icon(Icons.person_outline),
                            title: Text(membro.nomeMembro ?? ""),
                            onTap: () {
                              setState(() {
                                _membroSelecionado = membro;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  /// ================= EMPRESAS =================
                  Expanded(
                    flex: 4,
                    child:
                    _empresasDoSocio(_membroSelecionado, dado),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ================= EMPRESAS DO SOCIO =================

  Widget _empresasDoSocio(membro, dado) {
    if (membro == null) {
      return const Center(child: Text("Selecione um sócio"));
    }

    final empresaRaiz =
    (dado.empresaRaiz ?? '').toLowerCase().trim();

    final empresas = (membro.empresas ?? [])
        .where((emp) =>
    (emp.nomeEmpresaSocio ?? '')
        .toLowerCase()
        .trim() !=
        empresaRaiz &&
        emp.status?.text == "Ativa")
        .toList();

    if (empresas.isEmpty) {
      return const Center(
          child: Text("Sem empresas vinculadas"));
    }

    return ListView.builder(
      itemCount: empresas.length,
      itemBuilder: (_, i) {
        final emp = empresas[i];

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xffF4F6FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                emp.nomeEmpresaSocio ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),

              if (emp.cnpjEmpresaSocio != null)
                Text(
                    "CNPJ: ${Formatadores.formatarCnpj(emp.cnpjEmpresaSocio)}"),

              const SizedBox(height: 8),

              Text(
                "Status: ${emp.status?.text ?? ''}",
                style: const TextStyle(color: Colors.green),
              ),

              ...(emp.telefone ?? [])
                  .map((t) => Text("(${t.area}) ${t.number}")),

              ...(emp.email ?? [])
                  .map((e) => Text(e.address ?? "")),
            ],
          ),
        );
      },
    );
  }
}