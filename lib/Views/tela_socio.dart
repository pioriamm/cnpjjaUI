import 'package:flutter/material.dart';
import 'package:proj_flutter/Views/widgets/ClienteCardWidget.dart';
import 'package:proj_flutter/Views/widgets/FiltroBuscaWidget.dart';
import 'package:proj_flutter/Views/widgets/dialogs/NovoSocioDialog.dart';
import 'package:proj_flutter/Views/widgets/SideBarWidget.dart';
import 'package:proj_flutter/Views/widgets/botao_padrao.dart';

import '../Models/enum_MenuItem.dart';
import '../Models/novoLayout/Socios.dart';
import '../helprs/Cores.dart';

class TelaSocio extends StatefulWidget {

  TelaSocio({super.key});

  @override
  State<TelaSocio> createState() => _TelaSocioState();
}

class _TelaSocioState extends State<TelaSocio> {
  final List<Socio> listaSocios = [];

  MenuItem _selected = MenuItem.socios;

  final TextEditingController _filtroController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var tela = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(
        children: [
          /// SIDEBAR
          Container(width: tela.width * 0.2, height: double.infinity, child:  SideBarWidget(
        selectedItem: _selected,
        onItemSelected: (item) {
          setState(() {
            _selected = item;
          });
        },
      ),),
          /// CONTEÚDO PRINCIPAL
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: (tela.width * 0.09), vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// HEADER
                  Row(
                    children: [
                      Text(
                        "Sócios",
                        style: TextStyle(fontSize: 30, color: Cores.verde_escuro, fontWeight: FontWeight.bold),
                      ),

                      const Spacer(),

                      BotaoPadrao(
                        acao: () async {
                          final resultado = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const NovoSocioDialog(),
                          );

                          if (resultado != null) {
                            print(resultado);
                          }
                        },
                        cor: Cores.verde_escuro,
                        conteudo: [
                          Icon(Icons.add, color: Cores.branco),
                          const SizedBox(width: 8),
                          Text("Novo Sócio", style: TextStyle(color: Cores.branco, fontSize: 16)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text("${listaSocios.length} sócios cadastrados", style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 15),
                  FiltroBuscaWidget(

                    controller: _filtroController,
                    onChanged: (valor) {
                      print("Digitando: $valor");
                    }, hintText: 'Filtrar por nome ou CPF...',
                  ),

                  const SizedBox(height: 15),

                  Container(
                    height: tela.height * 0.74,
                    child: ListView.builder(
                      itemCount: 9,
                      itemBuilder: (item, context) => ClienteCardWidget(
                        nome: "Carlos Eduardo Mendes",
                        cpf: "123.456.789-00",
                        telefone: "(11) 98765-4321",
                        email: "carlos.mendes@email.com",
                        quantidadeEmpresas: 2,
                        onEdit: () {
                          print("Editar");
                        },
                        onDelete: () {
                          print("Excluir");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
