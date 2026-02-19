import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:proj_flutter/Models/status.dart';
import 'package:proj_flutter/Views/tela_prospectar.dart';
import '../Models/cnpjStatus.dart';
import '../helprs/formatadores.dart';
import 'widgets/SidebarItem.dart';

class TelaConsultaCnpjPage extends StatefulWidget {
  final List<String> cnpjs;

  const TelaConsultaCnpjPage({super.key, required this.cnpjs});

  @override
  State<TelaConsultaCnpjPage> createState() =>
      _TelaConsultaCnpjPageState();
}

class _TelaConsultaCnpjPageState
    extends State<TelaConsultaCnpjPage> {
  final List<CnpjStatus> _resultados = [];

  bool _processando = false;
  bool _cancelado = false;

  @override
  void initState() {
    super.initState();
    _resultados.addAll(
        widget.cnpjs.map((e) => CnpjStatus(cnpj: e)));
  }

  int get _total => _resultados.length;

  int get _restantes =>
      _resultados.where((e) => e.status != Status.ok).length;

  // ================= PROCESSAMENTO =================

  Future<void> _processarCnpjs() async {
    setState(() {
      _processando = true;
      _cancelado = false;
    });

    for (int i = 0; i < _resultados.length; i++) {
      if (_cancelado) break;

      if (_resultados[i].status == Status.ok) continue;

      await _processarCnpjIndividual(i);
      await Future.delayed(const Duration(milliseconds: 300));
    }

    setState(() => _processando = false);
  }

  Future<void> _processarCnpjIndividual(int index) async {
    if (_cancelado) return;

    setState(() {
      _resultados[index].status = Status.processando;
    });

    try {
      final response = await http.post(
        Uri.parse(
            '${dotenv.env['API_URL']}/cnpjja/popularBase'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode([
          {"cnpj": _resultados[index].cnpj}
        ]),
      );

      if (_cancelado) return;

      setState(() {
        _resultados[index].status =
        response.statusCode == 200
            ? Status.ok
            : Status.erro;
      });
    } catch (_) {
      setState(() {
        _resultados[index].status = Status.erro;
      });
    }
  }

  void _pararExecucao() {
    setState(() {
      _cancelado = true;
      _processando = false;
    });
  }

  // ================= STATUS ICON =================

  Widget _buildStatusWidget(Status status, int index) {
    switch (status) {
      case Status.processando:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );

      case Status.ok:
        return const Icon(Icons.check_circle,
            color: Colors.green);

      case Status.erro:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cancel, color: Colors.red),
            TextButton(
              onPressed: () =>
                  _processarCnpjIndividual(index),
              child: const Text("Retentar"),
            )
          ],
        );

      case Status.inicial:
        return const SizedBox();
    }
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF2F7),
      body: Row(
        children: [
          /// SIDEBAR
          _sideBar(),

          /// CONTEÚDO
          Expanded(
            child: Column(
              children: [
                _topBar(),
                Expanded(child: _conteudo()),
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),

          const ListTile(
            leading: Icon(Icons.storage),
            title: Text(
              "Popular\nBase",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          const Divider(),

          SidebarItem(
            icon: Icons.home,
            title: "Início",
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                transitionDuration:
                const Duration(milliseconds: 350),
                pageBuilder: (_, animation, __) =>
                const TelaProspectar(),
                transitionsBuilder:
                    (_, animation, __, child) {
                  final slideAnimation = Tween<Offset>(
                    begin: const Offset(0.08, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ),
                  );

                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: child,
                    ),
                  );
                },
              ),
                  (route) => false,
            ),
          ),

          const Spacer(),

          const SidebarItem(
            icon: Icons.settings,
            title: "Configurações",
          ),

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
        children: const [
          Expanded(
            child: Text(
              "Consulta de CNPJs",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }

  // ================= CONTEÚDO =================

  Widget _conteudo() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          /// CARD CONTROLE
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                    _infoBox("Total", _total),
                    _infoBox("Faltando", _restantes),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed:
                      _processando ? null : _processarCnpjs,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(_processando
                          ? "Processando..."
                          : "Iniciar"),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed:
                      _processando ? _pararExecucao : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red),
                      icon: const Icon(Icons.stop, color: Colors.white,),
                      label: const Text("Parar",style: TextStyle(color: Colors.white),),
                    ),
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// LISTA
          Expanded(
            child: ListView.builder(
              itemCount: _resultados.length,
              itemBuilder: (context, index) {
                final item = _resultados[index];

                return Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 6),
                  decoration: _cardDecoration(),
                  child: ListTile(
                    leading:
                    const Icon(Icons.work),
                    title: Text( Formatadores.formatarCnpj(item.cnpj) ),
                    trailing:
                    _buildStatusWidget(item.status, index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= WIDGETS AUX =================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(
          blurRadius: 12,
          color: Colors.black12,
          offset: Offset(0, 4),
        )
      ],
    );
  }

  Widget _infoBox(String titulo, int valor) {
    return Column(
      children: [
        Text(titulo,
            style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          "$valor",
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
