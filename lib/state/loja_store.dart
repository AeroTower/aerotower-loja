import 'package:flutter/foundation.dart';

import '../content/produtos.dart';

/// Filtros do catálogo + as escolhas do configurador.
///
/// Ficam juntos porque o protótipo os acopla: escolher "3 furos" na
/// barra lateral também predefine o configurador da PDP.
class LojaStore extends ChangeNotifier {
  String _busca = '';
  String _categoria = 'Todos';
  int _furoFiltro = 0; // 0 = Qualquer

  // ── Configurador (usado pelo card e, depois, pela PDP) ──
  String _cor = 'Terracota';
  int _furos = 3;
  int _modulos = 3;
  String _bomba = 'media';

  String get busca => _busca;
  String get categoria => _categoria;
  int get furoFiltro => _furoFiltro;
  String get cor => _cor;
  int get furos => _furos;
  int get modulos => _modulos;
  String get bomba => _bomba;

  set busca(String valor) {
    if (_busca == valor) return;
    _busca = valor;
    notifyListeners();
  }

  set categoria(String valor) {
    if (_categoria == valor) return;
    _categoria = valor;
    notifyListeners();
  }

  /// Como no protótipo: o filtro de furos NÃO reduz a grade — ele só
  /// predefine o configurador. Mantido igual de propósito.
  void selecionarFuroFiltro(int n) {
    _furoFiltro = n;
    if (n != 0) _furos = n;
    notifyListeners();
  }

  set cor(String valor) {
    if (_cor == valor) return;
    _cor = valor;
    notifyListeners();
  }

  set furos(int valor) {
    if (_furos == valor) return;
    _furos = valor;
    notifyListeners();
  }

  set bomba(String valor) {
    if (_bomba == valor) return;
    _bomba = valor;
    notifyListeners();
  }

  void aumentarModulos() {
    if (_modulos >= 12) return;
    _modulos++;
    notifyListeners();
  }

  void diminuirModulos() {
    if (_modulos <= 1) return;
    _modulos--;
    notifyListeners();
  }

  /// Categoria + busca (nome e resumo, sem diferenciar maiúsculas).
  List<Produto> get produtosFiltrados {
    final termo = normalizarBusca(_busca.trim());

    return produtos.where((p) {
      final naCategoria = _categoria == 'Todos' || p.categoria == _categoria;
      final naBusca = termo.isEmpty ||
          normalizarBusca('${p.nome} ${p.resumo}').contains(termo);
      return naCategoria && naBusca;
    }).toList();
  }

  String get tituloLista =>
      _categoria == 'Todos' ? 'Todos os produtos' : _categoria;

  String get contagem {
    final n = produtosFiltrados.length;
    return '$n ${n == 1 ? 'produto' : 'produtos'}';
  }
}

const _semAcento = {
  'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a',
  'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
  'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
  'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
  'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
  'ç': 'c', 'ñ': 'n',
};

/// Minúsculas e sem acento: quem busca no celular quase nunca digita acento
/// ("nivel de agua" precisa achar "nível de água"). CT-UNIT-03.
String normalizarBusca(String texto) => texto
    .toLowerCase()
    .split('')
    .map((letra) => _semAcento[letra] ?? letra)
    .join();
