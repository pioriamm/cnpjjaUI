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
  /// MÉTRICAS
  /// =========================

  int totalEmpresas = 0;
  int totalSocios = 0;
  int sociosDiretosUnicos = 0;
  int sociosIndiretosUnicos = 0;

  double get ticketMedio => totalEmpresas * 150.50;

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

      _calcularMetricas();

      print("paginaAtual: ${response.number}");
      print("totalPaginas: ${response.totalPages}");
      print("items: ${response.content.length}");

    } catch (e) {

      erro = e.toString();
      listaProspecao = [];
    }

    isLoading = false;

    notifyListeners();
  }

  /// =========================
  /// CALCULAR MÉTRICAS
  /// =========================

  void _calcularMetricas() {

    totalEmpresas = 0;
    totalSocios = 0;
    sociosDiretosUnicos = 0;
    sociosIndiretosUnicos = 0;

    final sociosDiretos = <String>{};
    final sociosIndiretos = <String>{};

    for (final prospect in listaProspecao) {

      totalEmpresas++;

      for (final dado in prospect.dados ?? []) {

        for (final membro in dado.membros ?? []) {

          if (membro.idMembro != null) {
            sociosDiretos.add(membro.idMembro!);
          }

          for (final empresa in membro.empresas ?? []) {

            for (final socio in empresa.membrosEmpresaSocio ?? []) {

              if (socio.id != null) {
                sociosIndiretos.add(socio.id!);
              }
            }
          }
        }
      }
    }

    sociosDiretosUnicos = sociosDiretos.length;
    sociosIndiretosUnicos = sociosIndiretos.length;

    final todosSocios = <String>{}
      ..addAll(sociosDiretos)
      ..addAll(sociosIndiretos);

    totalSocios = todosSocios.length;
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