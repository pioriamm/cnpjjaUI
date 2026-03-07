import 'package:flutter/material.dart';

import '../model/prospec.dart';
import '../repositorio/api_service.dart';

class BuscarBaseCnpjaProvider extends ChangeNotifier {

  /// =========================
  /// PAGINAÇÃO
  /// =========================

  int paginaAtual = 0;
  int totalPaginas = 0;

  final int pageSize = 20;

  /// =========================
  /// ESTADO
  /// =========================

  bool isLoading = false;
  String? erro;

  List<Prospectar> listaProspecao = [];

  /// =========================
  /// BUSCAR PAGINA
  /// =========================

  Future<void> buscarPagina(int pagina) async {

    if (isLoading) return;

    if (pagina < 0) pagina = 0;

    if (totalPaginas > 0 && pagina >= totalPaginas) {
      pagina = totalPaginas - 1;
    }

    isLoading = true;
    erro = null;

    notifyListeners();

    try {

      final response = await ApiService.buscarEmpresasBaseCnpjja(
        page: pagina,
        size: pageSize,
      );

      listaProspecao = List<Prospectar>.from(response.content);

      paginaAtual = response.number;
      totalPaginas = response.totalPages;

    } catch (e) {

      erro = e.toString();
      listaProspecao = [];
    }

    isLoading = false;

    notifyListeners();
  }


  /// =========================
  /// REFRESH
  /// =========================

  Future<void> refresh() async {

    if (paginaAtual < 0) {
      paginaAtual = 0;
    }

    await buscarPagina(paginaAtual);
  }
}