// Testes unitários de componentes e do estado da loja.
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aerotower_site/content/produtos.dart';
import 'package:aerotower_site/core/theme/at_shadows.dart';
import 'package:aerotower_site/core/theme/at_theme.dart';
import 'package:aerotower_site/core/widgets/at_foto.dart';
import 'package:aerotower_site/core/widgets/at_radio.dart';
import 'package:aerotower_site/core/widgets/at_tag.dart';
import 'package:aerotower_site/core/widgets/image_slot.dart';
import 'package:aerotower_site/core/widgets/video_slot.dart';
import 'package:aerotower_site/core/widgets/video_youtube.dart';
import 'package:aerotower_site/presentation/widgets/produto_card.dart';
import 'package:aerotower_site/state/carrinho_store.dart';
import 'package:aerotower_site/state/loja_store.dart';

import '../apoio.dart';

Future<void> _mostrar(WidgetTester tester, Widget w) async {
  tester.view.physicalSize = const Size(1200, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
      MaterialApp(theme: AtTheme.theme, home: Scaffold(body: Center(child: SizedBox(width: 900, child: w)))));
}

void main() {
  testWidgets('VideoSlot explica onde salvar o vídeo', (tester) async {
    await _mostrar(tester, const VideoSlot(titulo: 'Vídeo do pitch', caminhoArquivo: 'assets/videos/pitch.mp4'));
    expect(find.text('Vídeo do pitch'), findsOneWidget);
    expect(find.textContaining('assets/videos/pitch.mp4', findRichText: true), findsOneWidget);
  });

  testWidgets('ImageSlot mostra a descrição da foto que falta', (tester) async {
    await _mostrar(tester, const ImageSlot(descricao: 'Foto da torre na varanda', height: 120, width: 200));
    expect(find.text('Foto da torre na varanda'), findsOneWidget);
  });

  test('sombras e tema existem', () {
    expect(AtShadows.sm, isNotEmpty);
    expect(AtShadows.md, isNotEmpty);
    expect(AtShadows.lg, isNotEmpty);
    expect(AtTheme.theme.useMaterial3, isTrue);
  });

  group('LojaStore (configurador)', () {
    test('cor, furos e bomba avisam quem escuta só quando mudam', () {
      final loja = LojaStore();
      var avisos = 0;
      loja.addListener(() => avisos++);
      loja
        ..cor = 'Verde'
        ..cor = 'Verde'
        ..furos = 4
        ..furos = 4
        ..bomba = 'alta'
        ..bomba = 'alta'
        ..busca = 'kit'
        ..busca = 'kit';
      expect([loja.cor, loja.furos, loja.bomba, loja.busca], ['Verde', 4, 'alta', 'kit']);
      expect(avisos, 4);
    });

    test('módulos ficam entre 1 e 12', () {
      final loja = LojaStore();
      for (var i = 0; i < 20; i++) {
        loja.aumentarModulos();
      }
      expect(loja.modulos, 12);
      for (var i = 0; i < 20; i++) {
        loja.diminuirModulos();
      }
      expect(loja.modulos, 1);
    });

    test('filtro de furos também escolhe os furos do configurador', () {
      final loja = LojaStore()..selecionarFuroFiltro(3);
      expect(loja.furoFiltro, 3);
      expect(loja.furos, 3);
      loja.selecionarFuroFiltro(0);
      expect(loja.furoFiltro, 0);
      expect(loja.furos, 3, reason: '"Qualquer" não mexe no configurador');
    });
  });

  group('CarrinhoStore', () {
    test('mesmo item soma a quantidade; configuração diferente vira outra linha', () {
      final carrinho = CarrinhoStore();
      const verde = ItemCarrinho(id: 'modular', nome: 'HidroModular', precoUnitario: 89, cor: 'Verde', furos: 2);
      carrinho
        ..adicionar(verde)
        ..adicionar(verde)
        ..adicionar(const ItemCarrinho(id: 'modular', nome: 'HidroModular', precoUnitario: 101, cor: 'Verde', furos: 3));
      expect(carrinho.itens, hasLength(2));
      expect(carrinho.quantidadeTotal, 3);
      expect(carrinho.itens.first.total, 178);
      expect(carrinho.vazio, isFalse);
      carrinho.remover(verde.chave);
      expect(carrinho.quantidadeTotal, 1);
      carrinho.limpar();
      expect(carrinho.vazio, isTrue);
    });
  });

  testWidgets('foto que não existe mostra o fundo no lugar (sem quebrar a página)', (tester) async {
    await _mostrar(tester, const AtFoto('foto-que-nao-existe.jpg', height: 120));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(AtFoto), findsOneWidget);
  });

  testWidgets('etiquetas em todas as variantes', (tester) async {
    await _mostrar(tester, Wrap(children: [
      for (final v in AtTagVariant.values) AtTag(v.name, variant: v),
    ]));
    for (final v in AtTagVariant.values) {
      expect(find.text(v.name), findsOneWidget);
    }
  });

  testWidgets('opção marcada e desmarcada', (tester) async {
    var toques = 0;
    await _mostrar(tester, Row(children: [
      AtRadio(label: 'Sim', selecionado: true, onTap: () => toques++),
      AtRadio(label: 'Não', selecionado: false, onTap: () => toques++),
    ]));
    await tester.tap(find.text('Não'));
    expect(toques, 1);
  });

  testWidgets('card de produto sem foto: imagem e nome abrem o produto', (tester) async {
    const semFoto = Produto(
      id: 'teste', categoria: 'Add-ons', nome: 'Produto de teste', kicker: 'novo', slot: 'x',
      foto: 'Foto do produto de teste', resumo: 'Resumo', descricao: 'Descrição', specs: [],
      prefixo: 'a partir de',
    );
    var abriu = 0, adicionou = 0;
    await _mostrar(tester, ProdutoCard(
      produto: semFoto, preco: 99, onAbrir: () => abriu++, onAdicionar: () => adicionou++));
    await tester.tap(find.text('Foto do produto de teste'));
    await tester.tap(find.text('Produto de teste'));
    await tester.tap(find.text('Adicionar'));
    expect((abriu, adicionou), (2, 1));
  });

  testWidgets('vídeo do YouTube: miniatura reserva, destaque no mouse e abre em outra aba', (tester) async {
    final navegador = usarNavegadorFalso();
    await _mostrar(tester, const VideoYoutube(videoId: 'ai9nwWyfzMs'));
    await tester.pump(const Duration(milliseconds: 200));     // miniatura falha -> tenta a reserva
    await tester.pump(const Duration(milliseconds: 200));

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.byType(VideoYoutube)));
    await tester.pump();
    await mouse.moveTo(Offset.zero);
    await tester.pump();

    await tester.tap(find.byType(VideoYoutube));
    await tester.pump();
    expect(navegador.abertos.single, ('https://www.youtube.com/watch?v=ai9nwWyfzMs', '_blank'));
  });
}
