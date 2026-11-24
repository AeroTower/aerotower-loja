// CT-UNIT-03 (teste individual) — Busca da loja sem acento.
//
// Unidade testada: LojaStore.produtosFiltrados (filtro da busca da loja),
// sozinha, sem tela e sem rede.
// Quem procura no celular quase nunca digita acento. Hoje a busca só ignora
// maiúsculas: "nivel de agua" não acha o HidroFullkit, cujo texto diz
// "nível de água", e a pessoa vê "0 produtos".
// Falha de propósito enquanto o defeito existir.
@Tags(['defeito'])
library;

import 'package:aerotower_site/state/loja_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const casos = {
    'nivel de agua': 'HidroFullkit', //  texto do produto: "nível de água"
    'modulo': 'HidroModular', //         texto do produto: "O módulo que encaixa"
    'reservatorio': 'Kit Add-ons', //    texto do produto: "reservatório"
  };

  group('busca sem acento encontra o produto', () {
    for (final caso in casos.entries) {
      test('"${caso.key}" encontra ${caso.value}', () {
        final achados = (LojaStore()..busca = caso.key).produtosFiltrados.map((p) => p.nome).toList();
        expect(achados, contains(caso.value), reason: 'a busca devolveu $achados');
      });
    }
  });
}
