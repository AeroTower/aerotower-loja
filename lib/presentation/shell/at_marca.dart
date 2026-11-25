import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/rotas.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_icon.dart';

/// Gota + "AeroTower". Leva ao início.
class AtMarca extends StatelessWidget {
  const AtMarca({super.key});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(Rotas.inicio),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AtColors.accent200,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: AtIcon(AtIcons.droplet,
                    size: 20, color: AtColors.accent700),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('AeroTower', style: AtText.heading(20, height: 1.1)),
                Text(
                  'Hidroponia modular',
                  style: AtText.body(11,
                      color: AtColors.neutral700,
                      letterSpacing: 11 * 0.04,
                      height: 1.3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
