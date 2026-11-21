import 'package:flutter/material.dart';

import 'at_footer.dart';
import 'at_header.dart';
import 'at_menu_celular.dart';

/// Chrome comum a todas as telas: header fixo no topo, conteúdo rolável,
/// rodapé no fim. Cada transição de rota volta ao topo.
class AtShell extends StatefulWidget {
  /// Chave da rolagem da página (os testes medem a posição por ela).
  static const chaveRolagem = Key('rolagem-da-pagina');

  /// Endereço atual (ex.: /loja, /guias/montagem). Mudou = página nova.
  final String rota;
  final Widget child;

  const AtShell({super.key, required this.rota, required this.child});

  @override
  State<AtShell> createState() => _AtShellState();
}

class _AtShellState extends State<AtShell> {
  final ScrollController _scroll = ScrollController();

  @override
  void didUpdateWidget(AtShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Antes comparava o tipo do child, mas o child é sempre o Navigator das
    // rotas: o tipo nunca mudava e a página nova abria no meio da rolagem.
    if (oldWidget.rota != widget.rota && _scroll.hasClients) {
      _scroll.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Painel lateral do celular, aberto pelo botão de menu do header.
      endDrawer: const AtMenuCelular(),
      // SafeArea: no celular, o header não fica embaixo do notch.
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AtHeader(),
            Expanded(
              child: SingleChildScrollView(
                key: AtShell.chaveRolagem,
                controller: _scroll,
                child: Column(
                  children: [
                    widget.child,
                    const AtFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
