# libadwaita — Fork interno / Simulador de Balança

> **Este é um fork consolidado e modificado do package [`libadwaita`](https://pub.dev/packages/libadwaita)
> (gtk-flutter), mantido internamente como parte do projeto Simulador de Balança — ATAK.**

---

## Origem

Este package é uma **fusão consolidada** das seguintes bibliotecas open-source, que
originalmente eram packages separados e interdependentes:

| Package original | Pasta em `src/` | Função |
|---|---|---|
| [`libadwaita`](https://pub.dev/packages/libadwaita) | `widgets/`, `animations/`, `controllers/`, `models/`, `utils/`, `internal/` | Widgets GNOME Adwaita para Flutter |
| [`adwaita`](https://pub.dev/packages/adwaita) | `theme/` | `AdwaitaThemeData` e paleta `AdwaitaColors` |
| [`libadwaita_core`](https://pub.dev/packages/libadwaita_core) | `libadwaita_core/` | Tipos base: `AdwActions`, `AdwControls` |
| [`gsettings`](https://pub.dev/packages/gsettings) | `gsettings/` | Leitura de GSettings GNOME via D-Bus (lê accent color, layout de botões, etc.) |
| [`popover_gtk`](https://pub.dev/packages/popover_gtk) | `popover_gtk/` | Popover estilo GTK |

Todo o código foi incorporado diretamente ao repositório do projeto para permitir
modificações controladas e eliminar dependências de versões externas, garantindo
estabilidade e alinhamento total com o GNOME HIG.

## Modificações em relação ao original

### Novos widgets

| Widget | Descrição |
|---|---|
| `AdwCard` | Card não expansível com estilo Adwaita (elevation 0, borderRadius 12, borda sutil) |
| `AdwExpanderCard` | Card expansível com animação, substituindo o ExpansionTile do Material |

### Widgets estendidos

| Widget | O que foi adicionado |
|---|---|
| `AdwTextField` | Parâmetros `decoration`, `enabled`, `inputFormatters`, `readOnly` |

### Tema (`AdwaitaThemeData`)

- **`SliderThemeData`**: trilha inativa com cor neutra (`onSurface` a 18% de opacidade) em ambos os temas
- **Dark mode — `inputDecorationTheme`**: `floatingLabelStyle` e `focusedBorder` usam versão clareada do accent color via `_focusColorForDark()`, aplicada apenas no estado focado via `WidgetStateTextStyle`
- **`AdwaitaThemeData.light()` e `.dark()`**: integrados ao `ThemeNotifier` do app; accent color lido do SO via `dynamic_color`, usando sempre `lightDynamic?.primary` para ambos os modos (comportamento GNOME — mesmo accent no light e dark, sem desvio para pastel do Material You)

## Widgets disponíveis

### Adwaita
- `AdwButton` — botão base com estados hover/press, variantes `.circular`, `.pill`, `.flat`
- `AdwCard` — card estático estilo Adwaita *(novo neste fork)*
- `AdwExpanderCard` — card expansível com animação *(customizado neste fork)*
- `AdwTextField` — campo de texto com estilo Adwaita *(estendido neste fork)*
- `AdwSwitch` — toggle estilo GTK
- `AdwSwitchRow` — linha com switch integrado
- `AdwActionRow` — linha de ação estilo preferences
- `AdwComboRow` — linha com seletor dropdown
- `AdwPreferencesGroup` — grupo de preferências
- `AdwHeaderBar` — barra de título GNOME com leitura de GSettings
- `AdwScaffold` — scaffold com HeaderBar e Flap integrados
- `AdwSidebar` / `AdwSidebarItem` — navegação lateral
- `AdwAvatar` — avatar circular
- `AdwClamp` — limita largura do conteúdo
- `AdwFlap` — painel recolhível (flap/drawer)
- `AdwViewStack` / `AdwViewSwitcher` — navegação por abas estilo GNOME

### GTK
- `GtkDialog` — diálogo com HeaderBar integrada
- `GtkPopupMenu` — menu popup
- `GtkStackSidebar` — sidebar sincronizada com stack
- `GtkToggleButton` — botão com estado ativo

### Tema
- `AdwaitaThemeData.light()` / `.dark()` — temas completos
- `AdwaitaColors` — paleta completa do GNOME HIG

## Uso no projeto

```dart
import 'package:libadwaita/libadwaita.dart';
```

O package é referenciado via `path` no `pubspec.yaml` do projeto principal:

```yaml
dependencies:
  libadwaita:
    path: packages/libadwaita
```

## Mantenedor deste fork

**Reynegton Nunes — ATAK**
frigo02.claude@atak.com.br
Fork iniciado em 2026.

## Créditos — autores originais

- [@prateekmedia](https://github.com/prateekmedia) — criador e mantenedor original
- [@simrat39](https://github.com/simrat39) — widgets e example app
- [@MalcolmMielle](https://github.com/MalcolmMielle) — theming e CI
- [@jesusrp98](https://github.com/jesusrp98) — `AdwButton`, `AdwAvatar`
- [@pablojimpas](https://github.com/pablojimpas) — análise estática

Repositório original: https://github.com/gtk-flutter/libadwaita

## Licença

`Mozilla Public License 2.0` — ver [LICENSE](LICENSE).

Este fork mantém a licença original. Modificações realizadas neste fork estão sujeitas
aos mesmos termos da MPL 2.0, conforme exigido pela seção 3.1.
