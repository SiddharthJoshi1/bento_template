# AGENTS.md — bento_template

Agent-specific guidance for working in this repo. Read `CLAUDE.md` first for full architecture context.

---

## First-time setup

If the `content` branch does not yet exist on origin, run the setup script first:

```bash
bash scripts/init_content_branch.sh
```

This script must be run from the repo root while on `main`. It will:
- Extract `assets/data/content.json` from main using `git show` (no temp files)
- Create an orphan `content` branch with no shared history
- Wipe the working tree and restore only `content.json` at the correct path
- Commit and push to origin, then return you to main

Do not recreate these steps manually — the script handles edge cases and path construction correctly. If the `content` branch already exists, skip this entirely.

Verify setup succeeded:
```bash
git branch -r | grep content  # should show origin/content
```

---

## Before you start

Always run these before making changes:

```bash
flutter pub get
flutter analyze
```

`flutter analyze` must exit clean. If it doesn't, fix existing issues before introducing new ones.

---

## What you're allowed to touch freely

- `assets/data/content.json` — add, edit, reorder tiles; bump `version` if you do
- `lib/presentation/widgets/interactive_widgets/widgets/` — add new `InteractiveWidget` implementations
- `lib/presentation/widgets/bento_grid/tiles/renderers/` — add new renderers
- `lib/core/theme/theme_flavour.dart` — add or edit theme flavours
- `web/index.html` and `web/manifest.json` — meta, PWA config

---

## What to be careful with

- `lib/core/injector.dart` — all DI registration lives here. If you add a new repo or service, register it here. Don't register anything in `main.dart` or at call sites.
- `lib/domain/entities/tile_config.dart` — adding fields here requires updating `fromJson`, `copyWith`, and potentially renderers. Always check all three.
- `lib/presentation/blocs/portfolio/portfolio_bloc.dart` — the whole app shell depends on this. Don't change state transitions without checking `_PortfolioShell` in `main.dart`.
- `pubspec.yaml` — run `flutter pub get` after any changes here.

---

## What not to touch

- `lib/presentation/widgets/bento_grid/tiles/smart_bento_tile.dart` — only edit if you're adding a new `TileType`. It's a pure factory; keep it that way.
- `lib/core/network/cache_manager.dart` — the three-tier cache is load-bearing. Don't refactor without understanding the fallback chain.
- The `content` branch on GitHub — this is where the live `content.json` is served from. Don't push app code there. To initialise it, use `bash scripts/init_content_branch.sh` — never recreate the orphan branch manually.

---

## Layer rules — enforce these strictly

```
presentation → domain ← data
```

- `presentation` may never import from `data`
- `core` may not contain cubits, blocs, or any Bloc/Cubit state classes
- New repos go in `domain/repos/` (abstract) and `data/repos/` (implementation)
- New entities go in `domain/entities/`

If you're unsure which layer something belongs to, ask before creating the file.

---

## Adding a tile type — checklist

- [ ] Add value to `TileType` enum in `domain/entities/tile_config.dart`
- [ ] Add JSON key → enum mapping in `_typeFromString()`
- [ ] Add any new fields to `TileConfig` constructor, `fromJson`, and `copyWith`
- [ ] Create renderer at `presentation/widgets/bento_grid/tiles/renderers/<type>_tile_renderer.dart`
- [ ] Add case to switch in `smart_bento_tile.dart`
- [ ] Add example tile to `assets/data/content.json`
- [ ] Run `flutter analyze` — must pass clean

---

## Adding an interactive widget — checklist

- [ ] Create `presentation/widgets/interactive_widgets/<name>/<name>_widget.dart` implementing `InteractiveWidget`
- [ ] Import and register in `interactive_widget_registry.dart`: `'widget_id': () => YourWidget()`
- [ ] Add a `"type": "widgets"` tile to `content.json` with matching `widget_id`
- [ ] Run `flutter analyze` — must pass clean

---

## Content updates (no rebuild needed)

To update the live portfolio content without touching app code:

1. Edit `content.json`
2. Bump the `"version"` field (semver — any increment triggers a cache refresh)
3. Push to the `content` branch on GitHub

The app fetches from `raw.githubusercontent.com` on startup. If the remote version is newer than what's cached, it swaps the content automatically.

---

## Verification checklist (before any PR)

- [ ] `flutter analyze` passes with zero issues
- [ ] `flutter test` passes
- [ ] App loads correctly from bundled assets (disconnect network, hot restart)
- [ ] Theme toggle and flavour switching still work
- [ ] No new `presentation → data` imports introduced
- [ ] No new logic in `smart_bento_tile.dart` beyond a switch case

---

## Common mistakes to avoid

**Don't** add a new singleton directly in a widget — register it in `injector.dart` and resolve via `locator<T>()`.

**Don't** import `data/` from anywhere in `presentation/` — use domain types only.

**Don't** add fields to `TileConfig` without updating `fromJson` and `copyWith` — silent null bugs result.

**Don't** push to the `content` branch with app code — it's a content-only branch served via raw GitHub URLs.

**Don't** use `SystemChrome.setSystemUIOverlayStyle()` for web — it's a no-op. Browser chrome colour is set via `<meta name="theme-color">` in `web/index.html`.
