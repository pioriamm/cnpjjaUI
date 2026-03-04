import 'package:cnpjjaUi/repositorio/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'busca_base_conciliadora_provider.dart';

class PesquisaAtualizarBaseStatusProvider extends ChangeNotifier {
  String? loadingId;
  String? erro;

  bool isLoading(String id) => loadingId == id;

  Future<void> pesquisarEmpresa({
    required BuildContext context,
    required String cnpj,
    required String id,
    required String razaoSocial,
  }) async {
    final messenger = ScaffoldMessenger.of(context);

    loadingId = id;
    notifyListeners();

    try {
      final result = await ApiService.pesquisarCnpjja(cnpj);

      if (result == 200) {
        await ApiService.atualizarStatusEmpresa(id).then((valor) async {
          await context.read<BuscarBaseConciliadoraProvider>().carregarBase(
            context: context,
          );
        });
      }

      erro = null;
    } catch (e) {
      erro = e.toString();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text("Erro: $e"), backgroundColor: Colors.red),
        );
    }

    loadingId = null;
    notifyListeners();
  }
}
