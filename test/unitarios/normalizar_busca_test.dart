// normalizarBusca (CT-UNIT-03): a busca ignora acento e maiúscula nos dois
// sentidos, e a busca com acento continua funcionando.
import 'package:aerotower_site/state/loja_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('tira acento e cedilha e passa para minúsculas', () {
    expect(normalizarBusca('Nível de ÁGUA, Módulo, Reservatório, Ação'),
        'nivel de agua, modulo, reservatorio, acao');
  });

  test('busca com acento acha o mesmo produto que sem acento', () {
    final comAcento = (LojaStore()..busca = 'módulo').produtosFiltrados.map((p) => p.nome);
    final semAcento = (LojaStore()..busca = 'modulo').produtosFiltrados.map((p) => p.nome);
    expect(comAcento, isNotEmpty);
    expect(comAcento, semAcento);
  });
}
