import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/rotas.dart';
import '../../core/theme/at_theme.dart';

import 'at_botao_entrar.dart';
import 'at_campo_busca.dart';
import 'at_marca.dart';

/// O que no computador fica no topo: busca, links e o botão Entrar.
class AtMenuCelular extends StatelessWidget {
  const AtMenuCelular({super.key});

  @override
  Widget build(BuildContext context) {
    // Fecha o painel e depois navega, para a página nova já aparecer limpa.
    void irPara(String rota) {
      Scaffold.of(context).closeEndDrawer();
      context.go(rota);
    }

    return Drawer(
      backgroundColor: AtColors.bg,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const AtMarca(),
            const SizedBox(height: 20),
            AtCampoBusca(aoEnviar: () => Scaffold.of(context).closeEndDrawer()),
            const SizedBox(height: 12),
            _ItemMenu('Início', () => irPara(Rotas.inicio)),
            _ItemMenu('Loja', () => irPara(Rotas.loja)),
            _ItemMenu('Faça você mesmo', () => irPara(Rotas.diy)),
            const SizedBox(height: 12),
            const Divider(color: AtColors.divider),
            const SizedBox(height: 12),
            const AtBotaoEntrar(block: true),
          ],
        ),
      ),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final String label;
  final VoidCallback aoTocar;

  const _ItemMenu(this.label, this.aoTocar);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: aoTocar,
      borderRadius: BorderRadius.circular(AtRadius.pill),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Text(label, style: AtText.heading(20)),
      ),
    );
  }
}
