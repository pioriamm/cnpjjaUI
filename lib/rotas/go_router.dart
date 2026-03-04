import 'dart:html' as html;

import 'package:cnpjjaUi/view/telas/tela_empresas_resumo.dart';
import 'package:cnpjjaUi/view/telas/tela_empresas_socio.dart';
import 'package:cnpjjaUi/view/telas/tela_socio_cadastro.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/prospec.dart';
import '../view/telas/tela_carregar_base.dart';
import '../view/telas/tela_dashboard.dart';
import '../view/telas/tela_empresas.dart';
import '../view/telas/tela_empresas_cadastro.dart';
import '../view/telas/tela_socio.dart';

CustomTransitionPage buildPageWithTransition({
  required GoRouterState state,
  required Widget child,
  required String title,
}) {
  // altera o nome da aba
  html.document.title = title;

  return CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 250),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', redirect: (_, __) => '/pesquisa'),

    GoRoute(
      path: '/pesquisa',
      pageBuilder: (context, state) => buildPageWithTransition(
        state: state,
        child: TelaDashBoard(),
        title: 'Dashboard',
      ),
    ),

    GoRoute(
      path: '/empresa-socio',
      pageBuilder: (context, state) => buildPageWithTransition(
        state: state,
        child: TelaEmpresasSocio(),
        title: 'Empresa Sócios',
      ),
    ),

    GoRoute(
      path: '/carregar-base',
      pageBuilder: (context, state) => buildPageWithTransition(
        state: state,
        child: TelaCarregarBase(),
        title: 'Carregar Base',
      ),
    ),

    GoRoute(
      path: '/empresa-resumo',
      pageBuilder: (context, state) {
        final empresa = state.extra as Prospectar?;
        return buildPageWithTransition(
          state: state,
          child: TelaEmpresasResumo(empresa: empresa),
          title: 'Empresa Resumo',
        );
      },
    ),

    GoRoute(
      path: '/empresas',
      pageBuilder: (context, state) => buildPageWithTransition(
        state: state,
        child: TelaEmpresas(),
        title: 'Empresas',
      ),
    ),

    GoRoute(
      path: '/cadastro-empresas',
      pageBuilder: (context, state) => buildPageWithTransition(
        state: state,
        child: TelaEmpresasCadastro(),
        title: 'Cadastro Empresas',
      ),
    ),

    GoRoute(
      path: '/socios',
      pageBuilder: (context, state) => buildPageWithTransition(
        state: state,
        child: TelaSocio(),
        title: 'Sócios',
      ),
    ),

    GoRoute(
      path: '/castrar_socios',
      pageBuilder: (context, state) => buildPageWithTransition(
        state: state,
        child: TelaSocioCadastro(),
        title: 'Cadastrar Sócios',
      ),
    ),
  ],
);
