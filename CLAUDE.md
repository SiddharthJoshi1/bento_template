# CLAUDE.md — bento_template

This is a Flutter web portfolio app built with clean architecture, Bloc/Cubit state management, and JSON-driven content. It's also a **GitHub template** — developers fork it, replace `content.json`, and deploy their own bento-style portfolio.

---

## Architecture

Strict clean architecture. The rule is:

```
presentation → domain ← data
```

`presentation` may never import from `data`. `core` contains only infrastructure (no cubits, no state).

```
lib/
├── core/                        # Shared infrastructure — no layer-specific logic
│   ├── constants.dart
│   ├── injector.dart            # GetIt DI setup
│   ├── network/
│   │   ├── remote_json_source.dart   # HTTP GET for content.json
│   │   └── cache_manager.dart        # memory → SharedPrefs → bundled asset
│   ├── responsive/
│   │   ├── breakpoints.dart
│   │   └── mobile_tile_adapter.dart
│   └── theme/
│       ├── app_theme.dart       # AppTheme.light/dark(variant), AppColors, AppInsets
│       └── theme_flavour.dart   # ThemeFlavour + ThemeFlavours registry (6 flavours)
├── data/
│   ├── analytics/
│   │   └── lukehog_analytics_repo.dart
│   └── repos/
│       └── remote_config_repo.dart  # Orchestrates fetch, versioning, cache, parsing
├── domain/
│   ├── entities/
│   │   ├── tile_config.dart     # TileSize, TileType enums + TileConfig + fromJson
│   │   ├── profile_data.dart
│   │   ├── portfolio_content.dart
│   │   └── link.dart
│   └── repos/
│       ├── analytics_repo.dart  # Abstract AnalyticsRepository
│       └── link_repo.dart
└── presentation/
    ├── blocs/
    │   ├── portfolio/           # PortfolioBloc — loading/loaded/error
    │   └── theme/               # ThemeCubit — brightness + flavour, persisted
    ├── extensions/              # colour_extension, tile_size_extension, url_extension
    ├── helpers/                 # app_styles, icon_mapping, tile_constants, tile_image
    ├── pages/
    │   └── home_page.dart
    └── widgets/
        ├── bento_grid/
        │   ├── bento_sliver_list.dart
        │   └── tiles/
        │       ├── smart_bento_tile.dart          # Factory — switch on TileType
        │       ├── mouse_hover_effect.dart
        │       └── renderers/                     # One file per TileType
        ├── bento_states/
        ├── interactive_widgets/
        │   ├── interactive_widget.dart            # Abstract base class
        │   ├── interactive_widget_registry.dart   # widgetId → factory map
        │   └── <name>/                            # One folder per widget implementation
        ├── profile/
        └── theme_controls/
```

---

## Content system

All portfolio content lives in `content.json`. The app fetches it remotely on startup; the bundled copy at `assets/data/content.json` is the fallback.

**Remote source:** `content` branch on GitHub, served via `raw.githubusercontent.com`.

**Three-tier cache:** memory → SharedPrefs → bundled asset. The app always has content, even offline.

**To update content:** push a new `content.json` to the `content` branch. No rebuild needed. Bump `"version"` to trigger a cache refresh.

### content.json schema

```json
{
  "version": "1.0.0",
  "profile": {
    "name": "string",
    "bio": "string",
    "avatar_path": "string (asset path or URL)"
  },
  "tiles": [ ...TileConfig ]
}
```

### TileConfig fields

| Field | Type | Required | Notes |
|---|---|---|---|
| `type` | string | ✅ | See tile types below |
| `tile_size` | string | ✅ | See tile sizes below |
| `title` | string | most types | Display text |
| `url` | string | `link`, optional on `text` | Opens on tap |
| `image_path` | string | optional | Asset path or network URL |
| `colour` | string | `text` | Hex string e.g. `"#f9aa3a"` |
| `latitude` | number | `map` | |
| `longitude` | number | `map` | |
| `video_path` | string | `video` | Asset path or network URL |
| `widget_id` | string | `widgets` | Must match a key in `WidgetRegistry` |
| `widget_config` | object | `widgets` | Passed to `InteractiveWidget.buildWithConfig` |

### Tile types

| `type` value | Renderer | Notes |
|---|---|---|
| `section_title` | `SectionTitleRenderer` | Full-width label row |
| `link` | `LinkTileRenderer` | Tappable card, opens URL |
| `text` | `TextTileRenderer` | Coloured background, body text |
| `image` | `ImageTileRenderer` | Full-bleed image with optional title scrim |
| `map` | `MapTileRenderer` | Interactive OpenStreetMap, no API key needed |
| `video` | `VideoTileRenderer` | Muted looping video, asset or network |
| `widgets` | `InteractiveWidgetTileRenderer` | Resolved from `WidgetRegistry` by `widget_id` |

### Tile sizes

| `tile_size` value | Width | Height |
|---|---|---|
| `quarter_bar` | 25% | 0.5 units |
| `quarter_card` | 25% | 1.0 units |
| `quarter_tower` | 25% | 2.0 units |
| `half_bar` | 50% | 0.5 units |
| `half_card` | 50% | 1.0 units |
| `half_tower` | 50% | 2.0 units |
| `full_bar` | 100% | 0.5 units |
| `full_card` | 100% | 1.0 units |
| `full_tower` | 100% | 2.0 units |

---

## How to add a new tile type

1. Add a value to the `TileType` enum in `domain/entities/tile_config.dart`
2. Add the JSON key mapping in `TileConfig._typeFromString()`
3. Add any new fields to `TileConfig` and `TileConfig.fromJson()`
4. Create `presentation/widgets/bento_grid/tiles/renderers/your_type_renderer.dart`
5. Add a case to the switch in `SmartBentoTile`

---

## How to add a new interactive widget

1. Create `presentation/widgets/interactive_widgets/<name>/<name>_widget.dart` implementing `InteractiveWidget`
2. Import it in `interactive_widget_registry.dart` and add one entry to `_widgets`:
   ```dart
   'your_widget_id': () => YourWidget(),
   ```
3. Add a tile to `content.json` with `"type": "widgets"` and `"widget_id": "your_widget_id"`

No other changes needed — `SmartBentoTile` resolves everything via the registry.

---

## State management

| Concern | Mechanism |
|---|---|
| Portfolio data | `PortfolioBloc` (Bloc) |
| Theme | `ThemeCubit` (Cubit, persisted via SharedPrefs) |
| Everything else | `GetIt` service locator, resolved at call sites |

---

## Analytics

`AnalyticsRepository` is gated on `kReleaseMode` — events are no-ops in debug builds. The Lukehog app ID is injected at build time via the `LUKEHOG_APP_ID` environment variable. Three events are wired: `portfolio_opened`, `tile_tapped_<slug>`, `flutter_error`.

---

## Key invariants

- `presentation` never imports from `data`
- `core` contains no cubits, blocs, or state classes
- All DI registration happens in `core/injector.dart` — nowhere else
- `SmartBentoTile` is a pure factory — no business logic, no state
- Unknown `tile_size` values fall back to `halfCard`; unknown `type` values fall back to `text`
- The app must always render — never show a broken/empty state if the network is unavailable

---

## Commands

```bash
flutter run -d chrome                         # Run on web
flutter build web                             # Production build
flutter build web --dart-define=LUKEHOG_APP_ID=xxx  # With analytics
flutter analyze                               # Must pass clean before any PR
flutter test                                  # Run tests
```

---

## Related

- `AGENTS.md` — agent-specific workflow guidance
- `assets/data/content.json` — bundled content fallback
- `web/index.html` + `web/manifest.json` — PWA config
- `bento_layout` pub.dev package — Skyline bin-packing algorithm used by the grid
