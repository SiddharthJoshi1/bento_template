# Bento Template

A Flutter web portfolio template using a bento grid layout — differently-sized rectangular tiles packed tightly together, resembling a Japanese bento box.

Fork this repo, customise `content.json`, and deploy your own portfolio in under an hour. No backend required.

**[View live demo →](https://siddharthjoshi1.github.io/bento_template/)**

## Features

- **Bento grid layout** with 9 tile size variants combining width (quarter/half/full) and height (bar/card/tower)
- **Multiple tile types**: links, text, images, maps, videos, and interactive widgets
- **Remote JSON-driven content** — update your portfolio by pushing a new `content.json`, no rebuild required
- **Three-tier content cache**: in-memory → SharedPreferences → bundled asset fallback
- **6 theme flavours** (Chalk, Dusk, Espresso, Forest, Rose, Slate) with light/dark mode, persisted locally
- **Responsive design** across mobile, tablet, and desktop
- **GitHub Actions deploy workflow** included — push to `main` and your site deploys automatically
- **Analytics** via Lukehog (release mode only, injected at build time — optional)

## Quick start

Click **Use this template → Create a new repository**, then follow [`SETUP.md`](./SETUP.md).

## Documentation

| Guide | What it covers |
|---|---|
| [`SETUP.md`](./SETUP.md) | Fork, configure your content branch, personalise metadata, deploy |
| [`WIDGET_GUIDE.md`](./WIDGET_GUIDE.md) | Build your own interactive widgets — step-by-step with a working example |
| [`CLAUDE.md`](./CLAUDE.md) | Architecture reference, content schema, layer rules — for LLM agents and contributors |

## Architecture

Clean architecture with domain, data, and presentation layers.

**State management**
- `ThemeCubit` — brightness toggle and flavour switching, persisted via SharedPreferences
- `PortfolioBloc` — drives the app loading lifecycle: `loading → loaded / error`

**Content loading**
- On cold start, `PortfolioBloc` fires `LoadPortfolio`
- `RemoteConfigRepository` reads the best available JSON from `CacheManager` instantly, then attempts a remote fetch in the background
- If the remote `version` field is newer than the cached version, the cache is updated and the new content is used
- Failures at every tier fall through gracefully — the bundled `assets/data/content.json` is always the last resort

**Dependency injection**: GetIt

**Tile rendering**: factory-based `SmartBentoTile` delegating to specialised renderers per `TileType`

## Getting started (local dev)

```bash
flutter pub get
flutter run -d chrome
```

Pass your content URL to enable remote fetching locally:

```bash
flutter run -d chrome \
  --dart-define=CONTENT_BASE_URL=https://raw.githubusercontent.com/<you>/<repo>/content/
```

## Related

- [`bento_layout`](https://pub.dev/packages/bento_layout) — the pub.dev package powering the grid (Skyline bin-packing algorithm)
