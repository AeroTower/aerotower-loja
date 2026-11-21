// Testes de aceitação: critérios de aceite das histórias da loja, no
// formato BDD (Dado / Quando / Então), executados no site inteiro.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aerotower_site/presentation/pages/loja_page.dart';

import '../apoio.dart';

void main() {
  group('História: comprar uma torre', () {
    testWidgets(
        'Dado que estou na loja, '
        'Quando adiciono dois produtos, '
        'Então o carrinho do topo mostra 2 e cada clique é medido', (tester) async {
      final backend = await abrirSite(tester, rota: '/loja');
      await tocar(tester, find.text('Adicionar').at(0));
      await tester.pump(const Duration(seconds: 3));
      await tocar(tester, find.text('Adicionar').at(1));
      expect(find.text('2'), findsWidgets);
      expect(backend.eventos.where((e) => e == 'cta_add_carrinho'), hasLength(2));
    });

    testWidgets(
        'Dado que procuro uma bomba, '
        'Quando digito "bomba" na busca, '
        'Então vejo os add-ons e não os kits', (tester) async {
      await abrirSite(tester);
      await tester.enterText(find.byType(TextField).first, 'bomba');
      await esperar(tester);
      expect(find.byType(LojaPage), findsOneWidget);
      expect(find.text('Kit Add-ons'), findsWidgets);
      expect(find.text('HidroFullkit Pro'), findsNothing);
    });
  });

  group('História: acessar o painel da minha torre', () {
    testWidgets(
        'Dado que comprei uma torre, '
        'Quando clico em Entrar na loja, '
        'Então o painel abre em outra aba', (tester) async {
      final navegador = usarNavegadorFalso();
      await abrirSite(tester);
      await tocar(tester, find.text('Entrar').first);
      expect(navegador.abertos.single, ('https://app.aerotower.com.br/', '_blank'));
    });
  });
}
