import 'package:cnpjjaUi/helprs/configuracoes.dart';
import 'package:flutter/material.dart';

import '../model/prospec.dart';
import '../repositorio/api_service.dart';

class BuscarBaseCnpjaProvider extends ChangeNotifier {

  /// =========================
  /// PROPIEDADES
  /// =========================

  int? _totalSociosCache;
  int? _sociosDiretosCache;
  int? _sociosIndiretosCache;
  int _currentPage = 0;
  final int _pageSize = 50;

  bool isLoading = false;
  bool isLast = false;

  String? erro;
  DateTime? _lastFetch;
  static Duration _cacheDuration = Duration(minutes: Configuracoes.cache);
  List<Prospectar> listaProspecao = [];



  /// =========================
  /// GETTERS
  /// =========================


  //Todas as empresas prospectadas
  List<dynamic> get ListaEmpresasProspectadas => listaProspecao.expand((p) => p.dados ?? []).toList();

  int get totalEmpresas => listaProspecao.length;

  int get sociosDiretosUnicos {
    if (_sociosDiretosCache != null) return _sociosDiretosCache!;

    final ids = listaProspecao
        .expand((e) => e.dados ?? [])
        .expand((d) => d.membros ?? [])
        .map((m) => m.idMembro)
        .whereType<String>()
        .toSet();

    _sociosDiretosCache = ids.length;
    return _sociosDiretosCache!;
  }

  int get sociosIndiretosUnicos {

    if (_sociosIndiretosCache != null) return _sociosIndiretosCache!;

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

  int get totalSocios {

    if (_totalSociosCache != null) return _totalSociosCache!;

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

  double get ticketMedio => totalEmpresas * 150.50;

  /// =========================
  /// METODOS
  /// =========================

  Future<void> buscarDadosCnpja({bool reset = false}) async {

    if (isLoading) return;
    if (isLast && !reset) return;

    if (reset) {
      _currentPage = 0;
      isLast = false;
      listaProspecao.clear();
    }

    isLoading = true;
    erro = null;
    notifyListeners();

    try {
      final pageResponse = await ApiService.buscarEmpresasBaseCnpjja(
        page: _currentPage,
        size: _pageSize,
      );

      listaProspecao.addAll(pageResponse.content);

      isLast = pageResponse.last;
      _currentPage++;

      _invalidateMetrics();
    } catch (e) {
      erro = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await buscarDadosCnpja(reset: true);
  }

  void _invalidateMetrics() {
    _totalSociosCache = null;
    _sociosDiretosCache = null;
    _sociosIndiretosCache = null;
  }

}