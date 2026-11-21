import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/pages/diy_page.dart';
import '../../presentation/pages/em_breve_page.dart';
import '../../presentation/pages/guia_page.dart';
import '../../presentation/pages/inicio_page.dart';
import '../../presentation/pages/loja_page.dart';
import '../../presentation/shell/at_shell.dart';
import 'rotas.dart';

/// Troca de página sem animação.
///
/// O conteúdo fica dentro da rolagem do AtShell. Durante a animação padrão,
/// a página nova era desenhada com a altura da antiga: estourava (aviso de
/// layout) ou aparecia cortada até a animação acabar. Site não anima troca
/// de página; os testes de navegação pegaram isso.
Page<void> _pagina(GoRouterState state, Widget child) =>
    NoTransitionPage<void>(key: state.pageKey, child: child);

/// As oito rotas do handoff. Início, loja e os guias estão construídos;
/// as demais
/// respondem no endereço certo e mostram o placeholder até serem feitas.
final appRouter = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => AtShell(child: child),
      routes: [
        GoRoute(
          path: Rotas.inicio,
          pageBuilder: (context, state) => _pagina(state, const InicioPage()),
        ),
        GoRoute(
          path: Rotas.diy,
          pageBuilder: (context, state) => _pagina(state, const DiyPage()),
        ),
        GoRoute(
          path: Rotas.guia,
          pageBuilder: (context, state) => _pagina(
            state,
            GuiaPage(slug: state.pathParameters['slug'] ?? ''),
          ),
        ),
        GoRoute(
          path: Rotas.loja,
          pageBuilder: (context, state) => _pagina(state, const LojaPage()),
        ),
        GoRoute(
          path: Rotas.produto,
          pageBuilder: (context, state) => _pagina(
            state,
            EmBrevePage(titulo: 'Produto: ${state.pathParameters['id'] ?? ''}'),
          ),
        ),
        GoRoute(
          path: Rotas.carrinho,
          pageBuilder: (context, state) =>
              _pagina(state, const EmBrevePage(titulo: 'Carrinho')),
        ),
        GoRoute(
          path: Rotas.checkout,
          pageBuilder: (context, state) =>
              _pagina(state, const EmBrevePage(titulo: 'Finalizar compra')),
        ),
        GoRoute(
          path: Rotas.pedido,
          pageBuilder: (context, state) => _pagina(
            state,
            EmBrevePage(titulo: 'Pedido ${state.pathParameters['id'] ?? ''}'),
          ),
        ),
      ],
    ),
  ],
);
