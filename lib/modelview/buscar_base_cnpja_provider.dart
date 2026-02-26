import 'package:flutter/material.dart';

import '../model/prospec.dart';
import '../repositorio/api_service.dart';

class BuscarBaseCnpjaProvider extends ChangeNotifier {

  bool isLoading = false;
  List<Prospectar> listaProspecao = [];
  String? erro;

  Future<void> buscarDadosCnpja({
    required BuildContext context,
  }) async {

    final messenger = ScaffoldMessenger.of(context);

    isLoading = true;
    erro = null;
    notifyListeners();

    try {
      final result = await ApiService.buscarEmpresasBaseCnpjja();

      listaProspecao = result;

    } catch (e) {
      erro = e.toString();

      if (context.mounted) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text("Erro: $e"),
              backgroundColor: Colors.red,
            ),
          );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}