import 'package:cnpjjaUi/repositorio/api_service.dart';
import 'package:flutter/material.dart';

class AuditoriaProvider extends ChangeNotifier {

  int totalEmpresas = 0;
  int sociosDiretosUnicos = 0;
  int sociosIndiretosUnicos = 0;
  int totalSocios = 0;
  double ticketMedio = 0;

  bool loading = false;

  Future<void> buscarAuditoria() async {
    loading = true;
    notifyListeners();

    final data = await ApiService.buscarAuditoria();

    totalEmpresas = data['totalEmpresas'] ?? 0;
    sociosDiretosUnicos = data['sociosDiretosUnicos'] ?? 0;
    sociosIndiretosUnicos = data['sociosIndiretosUnicos'] ?? 0;
    totalSocios = data['totalSocios'] ?? 0;
    ticketMedio = (data['ticketMedio'] ?? 0).toDouble();

    loading = false;
    notifyListeners();
  }
}