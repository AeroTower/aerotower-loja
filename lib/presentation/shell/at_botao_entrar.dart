import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/api_config.dart';
import '../../core/config/app_links.dart';
import '../../core/theme/at_theme.dart';
import '../../core/widgets/at_button.dart';
import '../../core/widgets/at_icon.dart';
import '../../data/services/analytics_service.dart';

/// Leva da loja para o painel de monitoramento (sensores, dashboard, IA),
/// que é outra aplicação, em outro endereço. Abre em nova aba para não
/// derrubar o carrinho, que só existe em memória.
class AtBotaoEntrar extends StatelessWidget {
  /// Ocupa a largura toda, como no menu do celular.
  final bool block;

  const AtBotaoEntrar({super.key, this.block = false});

  Future<void> _abrirPainel(BuildContext context) async {
    context.read<AnalyticsService>().registrar(Eventos.entrarPainel);

    if (!AppLinks.painelPublicado) {
      _avisar(context, 'O painel ainda não está publicado.',
          duracao: const Duration(seconds: 3));
      return;
    }

    // resolve() continua aqui de propósito: com endereço absoluto ele
    // devolve o próprio endereço, e com um caminho relativo (se alguém
    // voltar a servir os dois no mesmo site) ele monta o absoluto a partir
    // da página atual. Os dois casos funcionam sem if.
    final destino = Uri.base.resolve(AppLinks.painel);
    final abriu = await launchUrl(destino, webOnlyWindowName: '_blank');

    if (!abriu && context.mounted) {
      _avisar(context, 'Não foi possível abrir o painel.');
    }
  }

  /// Aviso escuro e flutuante (antes o mesmo SnackBar estava escrito duas
  /// vezes). 4 s é o tempo padrão do Flutter.
  static void _avisar(
    BuildContext context,
    String texto, {
    Duration duracao = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(texto, style: AtText.body(14, color: AtColors.bg)),
          backgroundColor: AtColors.neutral900,
          behavior: SnackBarBehavior.floating,
          width: 320,
          duration: duracao,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AtButton(
      'Entrar',
      variant: AtButtonVariant.ghost,
      block: block,
      onPressed: () => _abrirPainel(context),
      leading: const AtIcon(AtIcons.login, size: 16, color: AtColors.accent700),
    );
  }
}
