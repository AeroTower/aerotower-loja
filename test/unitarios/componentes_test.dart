// Testes unitários de componentes e do estado da loja.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aerotower_site/core/theme/at_shadows.dart';
import 'package:aerotower_site/core/theme/at_theme.dart';
import 'package:aerotower_site/core/widgets/image_slot.dart';
import 'package:aerotower_site/core/widgets/video_slot.dart';
import 'package:aerotower_site/state/carrinho_store.dart';
import 'package:aerotower_site/state/loja_store.dart';

Future<void> _mostrar(WidgetTester tester, Widget w) => tester.pumpWidget(
      MaterialApp(theme: AtTheme.theme, home: Scaffold(body: Center(child: SizedBox(width: 420, child: w)))));

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
}
