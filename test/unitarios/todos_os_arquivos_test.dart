// Carrega todos os arquivos de lib/: assim a cobertura conta também o que
// nenhum outro teste abre (sem isso, o lcov ignora o arquivo e o número infla).
// ignore_for_file: unused_import
import 'package:flutter_test/flutter_test.dart';

import 'package:aerotower_site/content/guias.dart';
import 'package:aerotower_site/content/home.dart';
import 'package:aerotower_site/content/pilares.dart';
import 'package:aerotower_site/content/produtos.dart';
import 'package:aerotower_site/core/config/api_config.dart';
import 'package:aerotower_site/core/config/app_links.dart';
import 'package:aerotower_site/core/router/app_router.dart';
import 'package:aerotower_site/core/router/rotas.dart';
import 'package:aerotower_site/core/theme/at_colors.dart';
import 'package:aerotower_site/core/theme/at_shadows.dart';
import 'package:aerotower_site/core/theme/at_spacing.dart';
import 'package:aerotower_site/core/theme/at_text.dart';
import 'package:aerotower_site/core/theme/at_theme.dart';
import 'package:aerotower_site/core/util/moeda.dart';
import 'package:aerotower_site/core/widgets/at_button.dart';
import 'package:aerotower_site/core/widgets/at_foto.dart';
import 'package:aerotower_site/core/widgets/at_icon.dart';
import 'package:aerotower_site/core/widgets/at_radio.dart';
import 'package:aerotower_site/core/widgets/at_tag.dart';
import 'package:aerotower_site/core/widgets/image_slot.dart';
import 'package:aerotower_site/core/widgets/video_slot.dart';
import 'package:aerotower_site/core/widgets/video_youtube.dart';
import 'package:aerotower_site/data/services/analytics_service.dart';
import 'package:aerotower_site/main.dart';
import 'package:aerotower_site/presentation/pages/diy_page.dart';
import 'package:aerotower_site/presentation/pages/em_breve_page.dart';
import 'package:aerotower_site/presentation/pages/guia_page.dart';
import 'package:aerotower_site/presentation/pages/inicio_page.dart';
import 'package:aerotower_site/presentation/pages/loja_page.dart';
import 'package:aerotower_site/presentation/shell/at_footer.dart';
import 'package:aerotower_site/presentation/shell/at_botao_entrar.dart';
import 'package:aerotower_site/presentation/shell/at_campo_busca.dart';
import 'package:aerotower_site/presentation/shell/at_faixa_categorias.dart';
import 'package:aerotower_site/presentation/shell/at_header.dart';
import 'package:aerotower_site/presentation/shell/at_marca.dart';
import 'package:aerotower_site/presentation/shell/at_menu_celular.dart';
import 'package:aerotower_site/presentation/shell/at_shell.dart';
import 'package:aerotower_site/presentation/widgets/figura_guia.dart';
import 'package:aerotower_site/presentation/widgets/interesse_dialog.dart';
import 'package:aerotower_site/presentation/widgets/produto_card.dart';
import 'package:aerotower_site/state/carrinho_store.dart';
import 'package:aerotower_site/state/loja_store.dart';

void main() {
  test('todos os arquivos de lib/ compilam', () => expect(true, isTrue));
}
