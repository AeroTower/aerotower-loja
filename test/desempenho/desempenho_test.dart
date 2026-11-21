// Testes de desempenho da loja. Limites folgados (cerca de 10x o medido).
import 'package:flutter_test/flutter_test.dart';

import 'package:aerotower_site/state/carrinho_store.dart';
import 'package:aerotower_site/state/loja_store.dart';

import '../apoio.dart';

void main() {
  test('carga: 20.000 buscas digitadas filtram em menos de 1 s', () {
    final loja = LojaStore();
    final relogio = Stopwatch()..start();
    for (var i = 0; i < 20000; i++) {
      loja.busca = i.isEven ? 'kit' : 'bomba';
      loja.produtosFiltrados;
    }
    expect(relogio.elapsedMilliseconds, lessThan(1000));
  });

  test('volume: carrinho com 1.000 configurações diferentes', () {
    final carrinho = CarrinhoStore();
    final relogio = Stopwatch()..start();
    for (var i = 0; i < 1000; i++) {
      carrinho.adicionar(ItemCarrinho(id: 'modular', nome: 'HidroModular', precoUnitario: 89, cor: 'cor$i'));
    }
    expect(carrinho.itens, hasLength(1000));
    expect(relogio.elapsedMilliseconds, lessThan(1000));
  });

  testWidgets('a página inicial abre em menos de 3 s', (tester) async {
    final relogio = Stopwatch()..start();
    await abrirSite(tester);
    expect(relogio.elapsedMilliseconds, lessThan(3000));
  });
}
