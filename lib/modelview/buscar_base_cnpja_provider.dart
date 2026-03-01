import 'package:flutter/material.dart';
import 'package:cnpjjaUi/helprs/configuracoes.dart';

import '../model/prospec.dart';
import '../repositorio/api_service.dart';

class BuscarBaseCnpjaProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Prospectar> listaProspecao = [];
  String? erro;

  DateTime? _lastFetch;
  static Duration _cacheDuration =
  Duration(minutes: Configuracoes.cache);

  /// =========================
  /// CACHE COMPUTADO (performance)
  /// =========================
  int? _totalSociosCache;
  int? _sociosDiretosCache;
  int? _sociosIndiretosCache;

  void _invalidateMetrics() {
    _totalSociosCache = null;
    _sociosDiretosCache = null;
    _sociosIndiretosCache = null;
  }

  /// =========================
  /// EMPRESAS
  /// =========================
  int get totalEmpresas => listaProspecao.length;

  /// =========================
  /// SÓCIOS DIRETOS (únicos)
  /// =========================
  int get sociosDiretos {
    if (_sociosDiretosCache != null) {
      return _sociosDiretosCache!;
    }

    final ids = listaProspecao
        .expand((e) => e.dados ?? [])
        .expand((d) => d.membros ?? [])
        .map((m) => m.idMembro)
        .whereType<String>()
        .toSet();

    _sociosDiretosCache = ids.length;
    return _sociosDiretosCache!;
  }

  /// =========================
  /// SÓCIOS INDIRETOS (únicos)
  /// =========================
  int get sociosIndiretos {
    if (_sociosIndiretosCache != null) {
      return _sociosIndiretosCache!;
    }

    final ids = listaProspecao
        .expand((e) => e.dados ?? [])
        .expand((d) => d.membros ?? [])
        .expand((m) => m.empresas ?? [])
        .expand((emp) => emp.membrosEmpresaSocio ?? [])
        .map((m) => m.id)
        .whereType<String>()
        .toSet();

    _sociosIndiretosCache = ids.length;
    return _sociosIndiretosCache!;
  }

  /// =========================
  /// TOTAL SÓCIOS ÚNICOS
  /// =========================
  int get totalSocios {
    if (_totalSociosCache != null) {
      return _totalSociosCache!;
    }

    final ids = <String>{};

    for (final prospect in listaProspecao) {
      for (final dado in prospect.dados ?? []) {
        for (final membro in dado.membros ?? []) {
          if (membro.idMembro != null) {
            ids.add(membro.idMembro!);
          }

          for (final empresa in membro.empresas ?? []) {
            for (final socio in empresa.membrosEmpresaSocio ?? []) {
              if (socio.id != null) {
                ids.add(socio.id!);
              }
            }
          }
        }
      }
    }

    _totalSociosCache = ids.length;
    return _totalSociosCache!;
  }

  /// =========================
  /// MÉTRICAS
  /// =========================
  double get ticketMedio => totalEmpresas * 150.50;

  /// =========================
  /// BUSCA COM CACHE
  /// =========================
  Future<void> buscarDadosCnpja() async {
    final now = DateTime.now();

    if (_lastFetch != null &&
        now.difference(_lastFetch!) < _cacheDuration &&
        listaProspecao.isNotEmpty) {
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

      _invalidateMetrics(); // limpa cache calculado
    } catch (e) {
      erro = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}