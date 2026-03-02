import 'package:cnpjjaUi/model/dados.dart';
import 'package:flutter/material.dart';
import 'package:cnpjjaUi/helprs/configuracoes.dart';

import '../model/prospec.dart';
import '../repositorio/api_service.dart';

class BuscarBaseCnpjaProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLast = false;

  List<Prospectar> listaProspecao = [];
  String? erro;

  int _currentPage = 0;
  final int _pageSize = 50;

  DateTime? _lastFetch;
  static Duration _cacheDuration =
  Duration(minutes: Configuracoes.cache);


  int? _totalSociosCache;
  int? _sociosDiretosCache;
  int? _sociosIndiretosCache;

  List<dynamic> get empresasFlatten => listaProspecao.expand((p) => p.dados ?? []).toList();

  void _invalidateMetrics() {
    _totalSociosCache = null;
    _sociosDiretosCache = null;
    _sociosIndiretosCache = null;
  }


  int get totalEmpresas => listaProspecao.length;

  /// =========================
  /// MÉTRICAS (mantidas)
  /// =========================

  int get sociosDiretos {
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

  int get sociosIndiretos {
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
  /// PAGINAÇÃO
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
      final pageResponse =
      await ApiService.buscarEmpresasBaseCnpjja(
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
}

class PageResponse<T> {
  final List<T> content;
  final bool last;

  PageResponse({
    required this.content,
    required this.last,
  });

  factory PageResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT,) {
    return PageResponse(
      content: (json['content'] as List).map((e) => fromJsonT(e)).toList(),
      last: json['last'] ?? true,
    );
  }
}