// Testes funcionais: o site inteiro, navegando pelo header, como o visitante.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aerotower_site/core/router/app_router.dart';
import 'package:aerotower_site/main.dart' as site;
import 'package:aerotower_site/presentation/pages/diy_page.dart';
import 'package:aerotower_site/presentation/pages/em_breve_page.dart';
import 'package:aerotower_site/presentation/pages/inicio_page.dart';
import 'package:aerotower_site/presentation/pages/loja_page.dart';

import '../apoio.dart';

void main() {
  testWidgets('computador: header leva a Loja, Faça você mesmo, Início e Carrinho', (tester) async {
    await abrirSite(tester);
    expect(find.byType(InicioPage), findsOneWidget);
    expect(find.text('Frete grátis acima de 3 módulos'), findsOneWidget);

    await tocar(tester, find.text('Loja').first);
    expect(find.byType(LojaPage), findsOneWidget);

    await tocar(tester, find.text('Faça você mesmo').first);
    expect(find.byType(DiyPage), findsOneWidget);

    await tocar(tester, find.text('Início').first);
    expect(find.byType(InicioPage), findsOneWidget);

    await tocar(tester, find.text('Carrinho').first);
    expect(find.byType(EmBrevePage), findsOneWidget);
    await tocar(tester, find.text('Voltar ao início'));
    expect(find.byType(InicioPage), findsOneWidget);
  });

  testWidgets('categorias do header filtram a loja', (tester) async {
    await abrirSite(tester);
    await tocar(tester, find.text('Kits completos').first);
    expect(find.byType(LojaPage), findsOneWidget);
    expect(find.text('HidroFullkit'), findsWidgets);
    expect(find.text('Kit Add-ons'), findsNothing);
    await tocar(tester, find.text('Add-ons').first);
    expect(find.text('Kit Add-ons'), findsWidgets);
    await tocar(tester, find.text('HidroModular').first);
  });

  testWidgets('busca no header leva para a loja com o resultado', (tester) async {
    await abrirSite(tester);
    await tester.enterText(find.byType(TextField).first, 'pro');
    await esperar(tester);
    expect(find.byType(LojaPage), findsOneWidget);
    expect(find.text('HidroFullkit Pro'), findsWidgets);

    await tester.enterText(find.byType(TextField).first, 'xyz inexistente');
    await esperar(tester);
    expect(find.text('Nada encontrado'), findsOneWidget);
  });

  testWidgets('adicionar ao carrinho, abrir produto e voltar ao início', (tester) async {
    final backend = await abrirSite(tester, rota: '/loja');
    await tocar(tester, find.text('Adicionar').first);
    expect(find.textContaining('adicionado ao carrinho'), findsOneWidget);
    expect(backend.eventos, contains('cta_add_carrinho'));
    await tester.pump(const Duration(seconds: 3));

    await tocar(tester, find.text('Detalhes').first);
    expect(find.byType(EmBrevePage), findsOneWidget);
    expect(find.textContaining('Produto: '), findsOneWidget);
  });

  testWidgets('filtros da barra lateral e botões do topo da loja', (tester) async {
    final backend = await abrirSite(tester, rota: '/loja');
    await tocar(tester, find.text('3 furos'));
    await tocar(tester, find.text('Qualquer'));
    await tocar(tester, find.text('Montar minha torre'));
    await tocar(tester, find.text('Ver kits prontos'));
    await tocar(tester, find.text('Ver add-ons →'));
    expect(find.text('Kit Add-ons'), findsWidgets);
    expect(backend.eventos, containsAll(['cta_montar_torre', 'cta_ver_kits']));
  });

  testWidgets('rotas de checkout e pedido respondem no endereço certo', (tester) async {
    await abrirSite(tester, rota: '/checkout');
    expect(find.text('Finalizar compra'), findsOneWidget);
    await abrirSite(tester, rota: '/pedido/123');
    expect(find.text('Pedido 123'), findsOneWidget);
    await abrirSite(tester, rota: '/diy/torre-caseira');
    expect(find.textContaining('Faça você mesmo'), findsWidgets);
    await abrirSite(tester, rota: '/diy/guia-que-nao-existe');
    expect(find.text('Guia não encontrado'), findsOneWidget);
  });

  testWidgets('celular: menu lateral, carrinho com contador e busca', (tester) async {
    await abrirSite(tester, rota: '/loja', tamanho: const Size(520, 5000));
    expect(find.byTooltip('Abrir menu'), findsOneWidget);

    await tocar(tester, find.text('Adicionar').first);
    expect(find.text('1'), findsWidgets);

    await tocar(tester, find.byTooltip('Abrir menu'));
    expect(find.byType(Drawer), findsOneWidget);
    await tocar(tester, find.descendant(of: find.byType(Drawer), matching: find.text('Faça você mesmo')));
    expect(find.byType(DiyPage), findsOneWidget);

    await tocar(tester, find.byTooltip('Abrir menu'));
    await tester.enterText(find.descendant(of: find.byType(Drawer), matching: find.byType(TextField)), 'bomba');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await esperar(tester);
    expect(find.byType(LojaPage), findsOneWidget);

    await tocar(tester, find.byTooltip('Carrinho'));
    expect(find.byType(EmBrevePage), findsOneWidget);
    await tocar(tester, find.byTooltip('Abrir menu'));
    await tocar(tester, find.descendant(of: find.byType(Drawer), matching: find.text('Início')));
    expect(find.byType(InicioPage), findsOneWidget);
    await tocar(tester, find.byTooltip('Abrir menu'));
    await tocar(tester, find.descendant(of: find.byType(Drawer), matching: find.text('Loja')));
    expect(find.byType(LojaPage), findsOneWidget);
  });

  testWidgets('botão Entrar abre o painel em outra aba', (tester) async {
    final navegador = usarNavegadorFalso();
    final backend = await abrirSite(tester);
    await tocar(tester, find.text('Entrar').first);
    expect(navegador.abertos.single.$1, 'https://app.aerotower.com.br/');
    expect(navegador.abertos.single.$2, '_blank');
    expect(backend.eventos, contains('cta_entrar_painel'));
  });

  testWidgets('se o navegador não abrir, avisa', (tester) async {
    usarNavegadorFalso().abre = false;
    await abrirSite(tester);
    await tocar(tester, find.text('Entrar').first);
    expect(find.text('Não foi possível abrir o painel.'), findsOneWidget);
  });

  testWidgets('a marca volta ao início', (tester) async {
    await abrirSite(tester, rota: '/loja');
    await tocar(tester, find.text('AeroTower').first);
    expect(find.byType(InicioPage), findsOneWidget);
  });

  testWidgets('main() sobe o site na página inicial', (tester) async {
    appRouter.go('/');
    site.main();
    await esperar(tester);
    expect(find.byType(InicioPage), findsOneWidget);
  });
}
