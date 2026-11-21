import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/router/rotas.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_button.dart';
import '../../core/widgets/at_icon.dart';
import '../../state/carrinho_store.dart';

import 'at_botao_entrar.dart';
import 'at_campo_busca.dart';
import 'at_faixa_categorias.dart';
import 'at_marca.dart';

// Barra do topo do site. As peças que o menu do celular também usa
// (marca, busca, botão Entrar) ficam em arquivos próprios.

class AtHeader extends StatelessWidget {
  const AtHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final estreito = MediaQuery.sizeOf(context).width < 900;

    return Container(
      color: AtColors.bg,
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(boxShadow: AtShadows.sm),
            child: Container(
              color: AtColors.bg,
              padding: EdgeInsets.symmetric(
                horizontal: estreito ? 16 : 24,
                vertical: estreito ? 10 : 14,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: AtSpacing.maxWidth),
                  // Abaixo de 900 px não cabem busca, links e botões na mesma
                  // linha: eles vão para o menu, e o carrinho fica à vista.
                  child: estreito
                      ? const Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AtMarca(),
                              ),
                            ),
                            _CarrinhoCompacto(),
                            SizedBox(width: 8),
                            _BotaoMenu(),
                          ],
                        )
                      : const Row(
                          children: [
                            AtMarca(),
                            SizedBox(width: 20),
                            Expanded(child: AtCampoBusca()),
                            SizedBox(width: 20),
                            _NavDireita(),
                          ],
                        ),
                ),
              ),
            ),
          ),
          const AtFaixaCategorias(),
        ],
      ),
    );
  }
}

class _NavDireita extends StatelessWidget {
  const _NavDireita();

  @override
  Widget build(BuildContext context) {
    final quantidade =
        context.select<CarrinhoStore, int>((c) => c.quantidadeTotal);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Link('Início', () => context.go(Rotas.inicio)),
        const SizedBox(width: 16),
        _Link('Loja', () => context.go(Rotas.loja)),
        const SizedBox(width: 16),
        _Link('Faça você mesmo', () => context.go(Rotas.diy)),
        const SizedBox(width: 16),
        const AtBotaoEntrar(),
        const SizedBox(width: 10),
        AtButton(
          'Carrinho',
          variant: AtButtonVariant.secondary,
          onPressed: () => context.go(Rotas.carrinho),
          leading: const AtIcon(AtIcons.cart, size: 17, color: AtColors.text),
          trailing: Container(
            constraints: const BoxConstraints(minWidth: 20),
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: AtColors.accent,
              borderRadius: BorderRadius.circular(AtRadius.pill),
            ),
            child: Center(
              child: Text(
                '$quantidade',
                style: AtText.body(11, color: AtColors.bg, height: 1.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Carrinho do celular: só o ícone e a quantidade, para caber ao lado da marca.
class _CarrinhoCompacto extends StatelessWidget {
  const _CarrinhoCompacto();

  @override
  Widget build(BuildContext context) {
    final quantidade =
        context.select<CarrinhoStore, int>((c) => c.quantidadeTotal);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _BotaoRedondo(
          dica: 'Carrinho',
          icone: AtIcons.cart,
          aoTocar: () => context.go(Rotas.carrinho),
        ),
        if (quantidade > 0)
          Positioned(
            top: -2,
            right: -2,
            // Deixa o toque passar para o botão embaixo da quantidade.
            child: IgnorePointer(
              child: Container(
                constraints: const BoxConstraints(minWidth: 18),
                height: 18,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AtColors.accent700,
                  borderRadius: BorderRadius.circular(AtRadius.pill),
                ),
                child: Center(
                  child: Text(
                    '$quantidade',
                    style: AtText.body(11, color: AtColors.bg, height: 1.2),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _BotaoMenu extends StatelessWidget {
  const _BotaoMenu();

  @override
  Widget build(BuildContext context) {
    return _BotaoRedondo(
      dica: 'Abrir menu',
      icone: AtIcons.menu,
      aoTocar: () => Scaffold.of(context).openEndDrawer(),
    );
  }
}

/// Botão só com ícone. Tem 44 px, área de toque confortável no celular.
class _BotaoRedondo extends StatelessWidget {
  final String dica;
  final String icone;
  final VoidCallback aoTocar;

  const _BotaoRedondo({
    required this.dica,
    required this.icone,
    required this.aoTocar,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: dica,
      onPressed: aoTocar,
      constraints: const BoxConstraints.tightFor(width: 44, height: 44),
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        side: const BorderSide(color: AtColors.divider),
      ),
      icon: AtIcon(icone, size: 19, color: AtColors.text),
    );
  }
}

class _Link extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _Link(this.label, this.onTap);

  @override
  State<_Link> createState() => _LinkState();
}

class _LinkState extends State<_Link> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.label,
          style:
              AtText.body(14, color: _hover ? AtColors.accent : AtColors.text),
        ),
      ),
    );
  }
}
