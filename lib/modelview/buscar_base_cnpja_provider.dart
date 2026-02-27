import 'package:cnpjjaUi/helprs/configuracoes.dart';
import 'package:flutter/material.dart';

import '../model/prospec.dart';
import '../repositorio/api_service.dart';

class BuscarBaseCnpjaProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Prospectar> listaProspecao = [];
  String? erro;

  DateTime? _lastFetch;
  static  Duration _cacheDuration = Duration(minutes: Configuracoes.cache);

  Future<void> buscarDadosCnpja() async {

    final now = DateTime.now();

    if (_lastFetch != null && now.difference(_lastFetch!) < _cacheDuration && listaProspecao.isNotEmpty) {
      return;
    }

    await _executarBusca();
  }


  Future<void> refresh() async {
    _lastFetch = null;
    await _executarBusca();
  }

  Future<void> _executarBusca() async {
    isLoading = true;
    erro = null;
    notifyListeners();

    try {
      final result = await ApiService.buscarEmpresasBaseCnpjja();

      listaProspecao = result;
      _lastFetch = DateTime.now();
    } catch (e) {
      erro = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
