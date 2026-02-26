import 'package:flutter/material.dart';
import '../repositorio/api_service.dart';
import '../model/empresas_conciliadora.dart';

class BuscarBaseConciliadoraProvider extends ChangeNotifier {

  bool isLoading = false;
  List<EmpresasConciliadora> listaAtualizada = [];
  String? erro;

  int get quantidadePendentes => listaAtualizada.where((e) => e.pesquisado == false).length;

  Future<void> carregarBase({required BuildContext context}) async {

    final messenger = ScaffoldMessenger.of(context);

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
        ..showSnackBar(SnackBar(content: Text("Erro: $e"), backgroundColor: Colors.red));
    }

    isLoading = false;
    notifyListeners();
  }
}
