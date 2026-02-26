
import 'package:cnpjjaUi/modelview/busca_base_conciliadora_provider.dart';
import 'package:cnpjjaUi/rotas/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'modelview/atualizar_status_base_provider.dart';
import 'modelview/buscar_base_cnpja_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "local.env");
  usePathUrlStrategy();
  runApp(
    MultiProvider(
      providers:
      [
        ChangeNotifierProvider(create: (_) => PesquisaAtualizarBaseStatusProvider(),),
        ChangeNotifierProvider(create: (_) => BuscarBaseConciliadoraProvider(),),
        ChangeNotifierProvider(create: (_) => BuscarBaseCnpjaProvider(),),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter',
        progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF87b526), // cor do loader
      ),),
      routerConfig: appRouter,
    );
  }
}






