// Testes de segurança e privacidade da loja.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aerotower_site/core/config/api_config.dart';
import 'package:aerotower_site/data/services/analytics_service.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('clique não leva dado pessoal: só nome do botão, página e sessão anônima', () async {
    Map<String, dynamic>? enviado;
    final servico = AnalyticsService(
      baseUrl: 'https://api.teste',
      cliente: MockClient((req) async {
        enviado = jsonDecode(req.body) as Map<String, dynamic>;
        expect(req.headers.keys.map((k) => k.toLowerCase()), isNot(contains('cookie')));
        return http.Response('{}', 201);
      }),
    );
    await servico.registrar(Eventos.verKits, pagina: '/loja');
    expect(enviado!.keys.toSet(), {'nome', 'pagina', 'sessao'});
  });

  test('id de sessão é aleatório (128 bits), não deriva de nada do visitante', () async {
    final sessoes = <String>{};
    for (var i = 0; i < 50; i++) {
      SharedPreferences.setMockInitialValues({});
      final servico = AnalyticsService(
        baseUrl: 'https://api.teste',
        cliente: MockClient((req) async {
          sessoes.add((jsonDecode(req.body) as Map)['sessao'] as String);
          return http.Response('{}', 201);
        }),
      );
      await servico.registrar(Eventos.diy);
    }
    expect(sessoes, hasLength(50));
    expect(sessoes.every((s) => RegExp(r'^[0-9a-f]{32}$').hasMatch(s)), isTrue);
  });

  test('sem backend configurado, nada sai do navegador', () async {
    var chamadas = 0;
    final servico = AnalyticsService(baseUrl: '', cliente: MockClient((_) async {
      chamadas++;
      return http.Response('{}', 201);
    }));
    await servico.registrar(Eventos.diy);
    await expectLater(servico.registrarInteresse(email: 'a@b.com', produto: 'pro'),
        throwsA(isA<InteresseInvalido>()));
    expect(chamadas, 0);
  });

  test('endereços do backend e do painel usam https', () {
    expect(Uri.parse(ApiConfig.baseUrl).scheme, 'https');
    expect(ApiConfig.eventos, startsWith('https://'));
    expect(ApiConfig.interesse, endsWith('/eventos/interesse'));
    expect(ApiConfig.temBackend, isTrue);
  });
}
