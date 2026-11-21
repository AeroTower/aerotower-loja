// Apoio dos testes: o site inteiro com backend e navegador falsos.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'package:aerotower_site/core/router/app_router.dart';
import 'package:aerotower_site/data/services/analytics_service.dart';
import 'package:aerotower_site/main.dart';

/// Guarda o que o site mandaria ao Backend (eventos de clique e interesse).
class BackendFalso {
  final pedidos = <http.Request>[];
  int status = 201;

  http.Client get cliente => MockClient((pedido) async {
        pedidos.add(pedido);
        return http.Response.bytes(utf8.encode('{"sucesso": true}'), status,
            headers: {'content-type': 'application/json; charset=utf-8'});
      });

  /// Eventos registrados em /eventos (o nome de cada um).
  List<String> get eventos => pedidos
      .where((p) => p.url.path == '/eventos')
      .map((p) => (jsonDecode(p.body) as Map)['nome'] as String)
      .toList();
}

/// Navegador falso: anota os links abertos pelo botão "Entrar".
class NavegadorFalso extends UrlLauncherPlatform {
  final abertos = <(String, String?)>[];
  bool abre = true;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    abertos.add((url, options.webOnlyWindowName));
    return abre;
  }
}

NavegadorFalso usarNavegadorFalso() {
  final falso = NavegadorFalso();
  UrlLauncherPlatform.instance = falso;
  return falso;
}

/// Abre o site inteiro (LojaAeroTowerApp) na [rota], numa tela de [tamanho].
/// Os cliques vão para [backend].
Future<BackendFalso> abrirSite(WidgetTester tester,
    {String rota = '/', Size tamanho = const Size(1400, 4000), BackendFalso? backend}) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = tamanho;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final falso = backend ?? BackendFalso();
  await http.runWithClient(() async {
    appRouter.go(rota);
    await tester.pumpWidget(const LojaAeroTowerApp());
    await tester.pump();
    // O AnalyticsService e criado so no primeiro uso: cria aqui dentro, para
    // ele ja nascer falando com o backend falso.
    Provider.of<AnalyticsService>(tester.element(find.byType(Scaffold).first), listen: false);
    await tester.pump(const Duration(milliseconds: 300));
  }, () => falso.cliente);
  return falso;
}

/// Toca e espera a navegação/animação terminar.
Future<void> tocar(WidgetTester tester, Finder alvo) async {
  await tester.ensureVisible(alvo);
  await tester.pump();
  await tester.tap(alvo);
  await esperar(tester);
}

/// Algumas voltas de quadro: navegação, menus e avisos terminam de aparecer.
Future<void> esperar(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 150));
  }
}
