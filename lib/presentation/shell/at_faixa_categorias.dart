import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/router/rotas.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_icon.dart';
import '../../state/loja_store.dart';

/// Faixa abaixo do header: categorias da loja e o aviso de frete grátis.
class AtFaixaCategorias extends StatelessWidget {
  const AtFaixaCategorias({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AtColors.divider)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AtSpacing.maxWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Cada link define a categoria da barra lateral e volta à loja.
              void verCategoria(String categoria) {
                context.read<LojaStore>().categoria = categoria;
                context.go(Rotas.loja);
              }

              final categorias = [
                _LinkCategoria(
                    'HidroModular', () => verCategoria('HidroModular')),
                _LinkCategoria(
                    'Kits completos', () => verCategoria('Kits completos')),
                _LinkCategoria('Add-ons', () => verCategoria('Add-ons')),
              ];

              // Como no CSS: a faixa quebra em vez de esconder o frete.
              if (constraints.maxWidth < 620) {
                return Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 18,
                  runSpacing: 8,
                  children: [...categorias, const _FreteGratis()],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 18,
                      runSpacing: 8,
                      children: categorias,
                    ),
                  ),
                  const SizedBox(width: 18),
                  const _FreteGratis(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FreteGratis extends StatelessWidget {
  const _FreteGratis();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AtIcon(AtIcons.truck, size: 15, color: AtColors.accent2_700),
        const SizedBox(width: 7),
        Text(
          'Frete grátis acima de 3 módulos',
          style: AtText.body(13, color: AtColors.accent2_700),
        ),
      ],
    );
  }
}

class _LinkCategoria extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _LinkCategoria(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(label, style: AtText.body(13, color: AtColors.neutral700)),
      ),
    );
  }
}
