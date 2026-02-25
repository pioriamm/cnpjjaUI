import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import '../model/prospec.dart';
import '../view/tela_empresas.dart';
import '../view/tela_empresasCadastro.dart';
import '../view/tela_empresasSocio.dart';
import '../view/tela_empresasResumo.dart';
import '../view/tela_pesquisa.dart';
import '../view/tela_socio.dart';
import '../view/tela_socioCadastro.dart';

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
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/pesquisa',
    ),

    GoRoute(
      path: '/pesquisa',
      pageBuilder: (context, state) =>
          buildPageWithTransition(
            state: state,
            child: TelaPesquisa(), title: 'Dashboard',
          ),
    ),

    GoRoute(
      path: '/empresa-socio',
      pageBuilder: (context, state) =>
          buildPageWithTransition(

            state: state,
            child: TelaEmpresasSocio(), title: 'Empresa Sócios',
          ),
    ),

    GoRoute(
      path: '/empresa-resumo',
      pageBuilder: (context, state) {
        final empresa = state.extra as Prospectar?;

        return buildPageWithTransition(
          state: state,
          child: TelaEmpresasResumo(empresa: empresa), title: 'Empresa Resumo',
        );
      },
    ),

    GoRoute(
      path: '/empresas',
      pageBuilder: (context, state) =>
          buildPageWithTransition(
            state: state,
            child: TelaEmpresas(), title: 'Empresas',
          ),
    ),

    GoRoute(
      path: '/cadastro-empresas',
      pageBuilder: (context, state) =>
          buildPageWithTransition(
            state: state,
            child: TelaEmpresasCadastro(), title: 'Cadastro Empresas',
          ),
    ),

    GoRoute(
      path: '/socios',
      pageBuilder: (context, state) =>
          buildPageWithTransition(
            state: state,
            child: TelaSocio(), title: 'Sócios',
          ),
    ),

    GoRoute(
      path: '/castrar_socios',
      pageBuilder: (context, state) =>
          buildPageWithTransition(
            state: state,
            child: TelaSocioCadastro(), title: 'Cadastrar Sócios',
          ),
    ),
  ],
);