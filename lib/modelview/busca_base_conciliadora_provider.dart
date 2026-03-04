import 'package:cnpjjaUi/helprs/configuracoes.dart';
import 'package:flutter/material.dart';

import '../model/empresas_conciliadora.dart';
import '../repositorio/api_service.dart';

class BuscarBaseConciliadoraProvider extends ChangeNotifier {
  bool isLoading = false;
  List<EmpresasConciliadora> listaAtualizada = [];
  String? erro;
  DateTime? _lastFetch;
  static final _cacheDuration = Duration(minutes: Configuracoes.cache);

  int get quantidadePendentes =>
      listaAtualizada.where((e) => e.pesquisado == false).length;

  Future<void> carregarBase({required BuildContext context}) async {
    final messenger = ScaffoldMessenger.of(context);
    final now = DateTime.now();

    if (_lastFetch != null &&
        now.difference(_lastFetch!) < _cacheDuration &&
        listaAtualizada.isNotEmpty) {
      return;
    }

    isLoading = true;
    erro = null;
    notifyListeners();

    try {
      final result = await ApiService.buscarBaseConciliadora();

      listaAtualizada = result;
    } catch (e) {
      erro = e.toString();

      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text("Erro: $e"), backgroundColor: Colors.red),
        );
    }

    isLoading = false;
    notifyListeners();
  }
}
