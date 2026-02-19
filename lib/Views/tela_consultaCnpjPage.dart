import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proj_flutter/Models/status.dart';
import '../Models/cnpjStatus.dart';

class TelaConsultaCnpjPage extends StatefulWidget {
  final List<String> cnpjs;

  const TelaConsultaCnpjPage({super.key, required this.cnpjs});

  @override
  State<TelaConsultaCnpjPage> createState() => _TelaConsultaCnpjPageState();
}

class _TelaConsultaCnpjPageState extends State<TelaConsultaCnpjPage> {
  final List<CnpjStatus> _resultados = [];

  bool _processando = false;
  bool _cancelado = false;

  @override
  void initState() {
    super.initState();
    _resultados.addAll(
      widget.cnpjs.map((e) => CnpjStatus(cnpj: e)).toList(),
    );
  }

  int get _total => _resultados.length;

  int get _restantes =>
      _resultados.where((e) => e.status != Status.ok).length;

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

    setState(() {
      _processando = false;
    });
  }

  Future<void> _processarCnpjIndividual(int index) async {
    if (_cancelado) return;

    setState(() {
      _resultados[index].status = Status.processando;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/v1/cnpjja/pesquisar_cnpj'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode([
          {"cnpj": _resultados[index].cnpj}
        ]),
      );

      if (_cancelado) return;

      setState(() {
        _resultados[index].status =
        response.statusCode == 200 ? Status.ok : Status.erro;
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

  Widget _buildStatusWidget(Status status, int index) {
    switch (status) {
      case Status.processando:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );

      case Status.ok:
        return const Icon(Icons.check_circle, color: Colors.green);

      case Status.erro:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cancel, color: Colors.red),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => _processarCnpjIndividual(index),
              child: const Text("Retentar"),
            ),
          ],
        );

      case Status.inicial:
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta CNPJ')),
      body: Column(
        children: [
          const SizedBox(height: 16),

          /// CONTADORES
          Text("Total: $_total"),
          Text("Faltando: $_restantes"),

          const SizedBox(height: 16),

          /// BOTÕES
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _processando ? null : _processarCnpjs,
                child: Text(
                    _processando ? "Processando..." : "Iniciar Consulta"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _processando ? _pararExecucao : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("Parar"),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// LISTA
          Expanded(
            child: ListView.builder(
              itemCount: _resultados.length,
              itemBuilder: (context, index) {
                final item = _resultados[index];

                return ListTile(
                title: Text(item.cnpj),
                trailing:
                _buildStatusWidget(item.status, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}