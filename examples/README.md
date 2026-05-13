# examples/

Three starter `content.json` files showing different ways to use the template. Copy one into `assets/data/content.json` (and push to your `content` branch) as your starting point, then personalise from there.

---

## developer.json

Engineer or open source author. Project links with cover images, text tiles for stack/tools, recent writing section, a map tile, and a `counter_v1` widget. Tile mix leans on `half_tower` for visual weight on the projects section.

**Good for:** software engineers, indie hackers, OSS maintainers.

![Developer example](assets/Developer%20Content%20Bento.gif)

---

## designer.json

Visual and image-heavy. Four `image` tiles in the work section, text tiles for tool callouts with a bold accent colour, a `toggle_wall_v2` widget tuned to a neon palette, and a half-width map.

**Good for:** product designers, brand designers, creative directors.

![Designer example](assets/Designer%20Content%20Bento.gif)

---

## minimal.json

Just the essentials: bio, one project link, a text tile, a contact text tile, and four small link/map tiles in a grid. No widgets, no writing section. Loads fast and reads clean.

**Good for:** anyone who wants a low-maintenance presence, or a starting point before adding more tiles.

![Minimal example](assets/Minimal%20Bento.png)

---

## How to use

The fastest path is to pass your chosen example directly to the content branch setup script:

```bash
bash scripts/init_content_branch.sh examples/developer.json
```

This initialises the content branch from that file in one step. Then:

1. Replace placeholder text, URLs, and Unsplash image links with your own content
2. Bump `"version"` to `"1.0.1"` once you've made your first edit (so the cache refreshes on live visitors)
3. Push to your `content` branch

Alternatively, copy your chosen file to `assets/data/content.json` first, then run the script without arguments.

See [`SETUP.md`](../SETUP.md) for the full setup flow.
