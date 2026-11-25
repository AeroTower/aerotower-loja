import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/router/rotas.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_icon.dart';
import '../../state/loja_store.dart';

/// Filtra a grade da loja a cada tecla. Digitar fora de /loja leva
/// para lá, senão o resultado da busca ficaria invisível.
class AtCampoBusca extends StatefulWidget {
  /// Chamado ao apertar Enter. O menu usa para fechar e mostrar o resultado.
  final VoidCallback? aoEnviar;

  const AtCampoBusca({super.key, this.aoEnviar});

  @override
  State<AtCampoBusca> createState() => _AtCampoBuscaState();
}

class _AtCampoBuscaState extends State<AtCampoBusca> {
  late final TextEditingController _controller =
      TextEditingController(text: context.read<LojaStore>().busca);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _aoDigitar(String valor) {
    context.read<LojaStore>().busca = valor;
    if (valor.trim().isNotEmpty &&
        GoRouterState.of(context).uri.path != Rotas.loja) {
      context.go(Rotas.loja);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
        decoration: BoxDecoration(
          color: AtColors.surface,
          borderRadius: BorderRadius.circular(AtRadius.pill),
        ),
        child: Row(
          children: [
            const AtIcon(AtIcons.search, size: 17, color: AtColors.neutral700),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: _aoDigitar,
                onSubmitted: (_) => widget.aoEnviar?.call(),
                style: AtText.body(14),
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Buscar módulos, kits e bombas',
                  hintStyle:
                      AtText.body(14, color: AtColors.mix(AtColors.text, 0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
