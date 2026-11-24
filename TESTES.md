# Testes da loja

**Responsável:** Caio (os 6 casos formais dele estão no `TESTES.md` do app) · **Cobertura:** 91,3% (meta da disciplina: 90%) · **86 testes**

| Tipo | Pasta | Testes | O que confere |
|---|---|---:|---|
| Unitário | `test/unitarios/` | 38 | preços, carrinho, filtros da loja, links, componentes (foto, etiqueta, opção, card, vídeo) |
| Integração | `test/integracao/` | 11 | `AnalyticsService` e formulário de interesse falando com um backend falso |
| Funcional | `test/funcionais/` | 27 | o site inteiro pelo header: páginas, categorias, busca, carrinho, menu do celular, botão Entrar |
| Aceitação | `test/aceitacao/` | 3 | histórias "comprar uma torre" e "acessar o painel", em BDD (Dado / Quando / Então) |
| Desempenho | `test/desempenho/` | 3 | 20.000 buscas; carrinho com 1.000 configurações; página inicial abrindo |
| Segurança | `test/seguranca/` | 4 | clique sem dado pessoal; sessão anônima de 128 bits; nada sai sem backend; tudo em https |

Os testes que já existiam (`loja_test`, `links_test`, `validacao_test`, `inicio_test`, `diy_test`) foram mantidos, só mudaram para as pastas por tipo.

## Como rodar

```bash
flutter pub get
flutter test                   # todos
flutter test --coverage        # com cobertura (coverage/lcov.info)
flutter test test/funcionais   # só um tipo (pela pasta)
```

**GitHub:** o workflow `.github/workflows/testes.yml` roda em todo pull request. Falha abaixo de 90% e mostra, na aba *Actions*, a tabela por tipo e as linhas sem teste de cada arquivo.

## Achados durante os testes

| # | Achado | Situação |
|---|---|---|
| 1 | Na troca de página, a página nova era desenhada com a altura da antiga durante a animação: estouro de layout (no site, conteúdo cortado até a animação acabar) | **Corrigido:** as rotas trocam sem animação (`NoTransitionPage` em `app_router.dart`) |
| 2 | O deploy quebrava em todo push: o Flutter 3.47 marcou `material.dart` como obsoleto e o `flutter analyze` tratava esse aviso ("info") como erro | **Corrigido:** `flutter analyze --no-fatal-infos`, igual ao app |
| 3 | O "volta ao topo a cada troca de página" do `AtShell` nunca é executado: o `child` é sempre o `Navigator` das rotas, então o tipo não muda | Corrigido na refatoração: o `AtShell` recebe a rota atual (`state.uri.path`) e volta ao topo quando ela muda. Teste: "trocar de página volta ao topo da rolagem" |
| 4 | O índice de guias (`_Indice`, em `diy_page.dart`) só aparece com 2 guias ou mais; hoje há 1, então essas linhas não têm como ser testadas | Esperado: entra no teste quando houver o segundo guia |

## Teste individual que acha defeito (Fernão, parte do Caio)

| ID | Tipo | Defeito que o teste mostra | Onde |
|---|---|---|---|
| CT-UNIT-03 | Unitário | A busca só ignora maiúsculas, não acentos: "nivel de agua", "modulo" e "reservatorio" devolvem 0 produtos | `test/unitarios/individual_busca_sem_acento_test.dart` |

Tem a tag `defeito`: fica fora do passo de cobertura e do deploy, e roda
num passo próprio do CI ("Testes que acham defeitos"), que aparece em
vermelho sem derrubar o job. Para rodar só ele:

```bash
flutter test --tags defeito
```

Os testes web da loja (CT-DESEMP-03, Lighthouse; CT-SEG-03, ZAP e
clickjacking) estão descritos em `projeto_aeroponia/testes-web/README.md`.
