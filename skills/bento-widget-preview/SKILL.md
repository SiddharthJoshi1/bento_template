# SKILL: bento-widget-preview

## Purpose

Generate an HTML file that previews **five distinct design variants** of an interactive widget, each rendered inside a correctly-proportioned bento tile. Use this before building anything in Flutter — explore layout and interaction in HTML, pick the winning direction, then use the AGENT_HANDOFF as the implementation spec.

Each output file contains an `AGENT_HANDOFF` block that the `bento-widget-complete` skill reads to implement the widget in Flutter. The handoff block is the contract between the preview and the implementation — write it carefully.

---

## When to use this skill

- You're designing a new `InteractiveWidget` and want to explore how it feels inside a tile before writing Dart
- You want five meaningfully different design directions side by side before committing to one
- You want a shareable HTML mockup to review before starting implementation

---

## Default behaviour

**Always generate five variants.** Do not generate fewer unless the user explicitly asks for a specific count. The five variants must be genuinely different design directions — not superficial colour or font tweaks. Think: different interaction models, different information hierarchies, different visual metaphors, different density trade-offs.

Good examples of genuinely distinct variants for an article list widget:
- Minimal rows with emoji markers
- Card stack with coloured left-edge accent
- Magazine grid with alternating tints
- Timeline with date anchors
- Compact chips with tap-to-expand

Bad examples (not distinct enough):
- Same card layout with different border radius
- Same layout with dark vs light background

---

## Tile size reference

All sizes come from `CLAUDE.md`. Use these to size the tile containers in the HTML:

| tile_size | Width | Aspect behaviour |
|---|---|---|
| `quarter_card` | 25% | Square-ish |
| `quarter_tower` | 25% | Tall |
| `half_card` | 50% | Square-ish |
| `half_tower` | 50% | Tall |
| `full_card` | 100% | Wide, short |
| `full_tower` | 100% | Wide, tall |

For HTML prototyping, translate these to approximate pixel dimensions at a 1200px grid width:
- quarter = ~280px wide
- half = ~580px wide
- full = ~1160px wide
- card height ≈ width (square)
- tower height ≈ 2× width
- bar height ≈ 0.5× width

**Preview tile sizing:** Regardless of the widget's intended tile_size, always render preview tiles at `quarter_tower` dimensions (~280px wide × ~560px tall). This keeps all five variants compact and comparable on screen without scrolling. The tile_size in the AGENT_HANDOFF is the intended Flutter size — the HTML preview dimensions are just for prototyping.

---

## HTML output rules

1. **Neutral styling.** Light grey page background (`#F5F5F5`), white tile backgrounds, 12px border radius, soft box shadow. Do not apply brand colours unless asked.

2. **Tile containers must respect aspect ratios.** Use CSS `aspect-ratio` or explicit height from the tile size table. The widget fills the tile — no overflow, no scroll inside the tile.

3. **Interactive elements are required.** If the widget concept involves animation, toggling, sliders, or gestures — prototype them in HTML/CSS/JS. The goal is to feel the interaction, not see a static mockup. Every variant should have at least one interactive element.

4. **Each tile gets a label.** Below the UX callout strip: `widget_id` in monospace and `tile_size` as a badge.

5. **UX callout block on every tile (REQUIRED).** Immediately below each tile container, render a compact callout strip with three rows:
   - 🖥 **Web:** one sentence on what works and what doesn't at this tile size on web
   - 📱 **Mobile:** one sentence on touch targets, gesture comfort, and mobile-specific concerns
   - ⚖️ **Tradeoff:** one sentence on what this variant prioritises and what it sacrifices

   These must be populated from the `HANDOFFS` object and also rendered statically on each tile card so all five can be compared at a glance without opening the handoff panel. Do not hide them behind the panel.

6. **"Select this variant" button on each tile.** Clicking it:
   - Highlights that tile with a coloured ring + "Selected" badge
   - Removes highlights from all other tiles
   - Updates the handoff panel to show the AGENT_HANDOFF for that variant
   - Updates the `content.json` snippet below the panel

7. **Page structure:**
   ```
   <header>  — widget concept name, tile_size used, date
   <main>    — five tiles in a responsive grid
   <section id="handoff-panel">  — live AGENT_HANDOFF driven by variant selection
   <section class="snippet-section">  — content.json snippet
   <footer>  — "Prototype only. Implement in Flutter via InteractiveWidget."
   ```

8. **No external dependencies.** Vanilla HTML, CSS, JS only. No CDN imports. The file must open offline.

9. **Handoff panel.** On page load, the agent's recommended variant is pre-selected (variant recommended by the agent, not necessarily v1). When the user clicks "Select this variant":
   - Handoff panel updates to that variant's AGENT_HANDOFF block
   - content.json snippet updates to that variant's `suggested_widget_config`

   The panel must include:
   - Variant name and tile size
   - Full AGENT_HANDOFF block as copyable preformatted text with a "Copy AGENT_HANDOFF" button
   - Scaffold command in a distinct code block with its own copy button

---

## AGENT_HANDOFF schema

Every HTML output file MUST contain exactly one static `AGENT_HANDOFF` block as an HTML comment, placed immediately before the closing `</body>` tag. This static block reflects the **pre-selected (recommended) variant**. The user overrides it by clicking "Select this variant" — the panel generates the correct block for their chosen variant dynamically.

The block MUST follow this schema exactly — same key names, same order:

```
<!-- AGENT_HANDOFF
widget_id: <snake_case_v1>
variant: <chosen variant name>
tile_size: <tile_size>
display_name: <Human Readable Name>
description: <one paragraph — describe the interaction model precisely enough that a Flutter dev can implement it without seeing the HTML>
painter_needed: true | false
web_ux: <one sentence — what works well on web and what doesn't at this tile size>
mobile_ux: <one sentence — what works well on mobile and what doesn't at this tile size>
tradeoff: <one sentence — what this variant prioritises and what it sacrifices>
config_schema:
  <key>: <type> (<constraints, default value>)
  <key>: <type> (<constraints, default value>)
suggested_widget_config:
  <key>: <value>
  <key>: <value>
scaffold_command: dart run tool/new_widget.dart <widget_id>
END_HANDOFF -->
```

### Schema rules

- `widget_id` — must be snake_case ending in `_v<number>`, e.g. `mood_tracker_v1`
- `variant` — name of the chosen variant as it appears in the HTML labels
- `tile_size` — must be a valid tile_size from the reference table above
- `display_name` — title case, no version suffix, e.g. `Mood Tracker`
- `description` — be specific about gestures, animation behaviour, segment counts, colour logic, state transitions. This is what the Flutter agent reads to implement. Vague descriptions produce bad code.
- `painter_needed` — `true` if the widget uses `CustomPainter`, `false` if standard Flutter widgets suffice
- `web_ux` — specific to this tile_size. What works with hover/mouse/cursor, what doesn't.
- `mobile_ux` — specific to this tile_size. Touch target sizes (flag anything under 44px), gesture comfort, thumb reach.
- `tradeoff` — what this variant prioritises (density, visual interest, simplicity, scannability) and what it sacrifices.
- `config_schema` — one line per configurable key, indented with two spaces. Include type, constraints, and default.
- `suggested_widget_config` — concrete default values ready to paste into `content.json`. Must match `config_schema` keys exactly.
- `scaffold_command` — always `dart run tool/new_widget.dart <widget_id>` (no tile_size argument)

### JS HANDOFFS object (required)

The `HANDOFFS` JS object must contain one entry per variant, keyed by `data-variant` value (e.g. `"v1"` through `"v5"`). Each entry mirrors the AGENT_HANDOFF schema:

```js
const HANDOFFS = {
  v1: {
    widget_id: 'my_widget_v1',
    variant: 'Minimal Rows',
    tile_size: 'half_card',
    display_name: 'My Widget',
    description: `Precise multi-line description...`,
    painter_needed: false,
    web_ux: 'Hover highlight works cleanly; mouse precision makes the tap target comfortable at half_card.',
    mobile_ux: 'Touch targets are adequate at half_card; ensure row height is at least 44px.',
    tradeoff: 'Prioritises scannability and density; sacrifices visual richness.',
    config_schema: [
      { key: 'heading', type: 'String', note: 'default "Title"' },
    ],
    suggested_widget_config: {
      heading: 'Title',
    },
    scaffold_command: 'dart run tool/new_widget.dart my_widget_v1',
  },
  v2: { /* ... */ },
  v3: { /* ... */ },
  v4: { /* ... */ },
  v5: { /* ... */ },
};
```

The handoff panel JS reads the selected variant's entry and renders both the copyable `<!-- AGENT_HANDOFF ... END_HANDOFF -->` block and the scaffold command.

### Good description example

```
description: A rotary dial rendered with CustomPainter. The dial spans 270 degrees
  (from 225deg to 135deg clockwise). It is divided into N equal segments, each a
  different colour. The user drags anywhere on the canvas — the angle from centre to
  pointer maps to the active segment index. The needle rotates smoothly to track the
  pointer. On pointer up, the selected segment index is stored in state and the label
  beneath the dial updates. No animation controller needed — state is driven entirely
  by gesture position.
```

### Bad description example

```
description: A dial the user can drag to pick a mood.
```

---

## content.json snippet

After the handoff panel, append a ready-to-use `content.json` tile snippet. This updates dynamically when a variant is selected, showing that variant's `suggested_widget_config`. Include a copy button.

---

## Output location and filename

Save all generated HTML files to:

```
skills/bento-widget-preview/outputs/<widget_id>-preview.html
```

Never save to the project root or elsewhere. No mode suffix in the filename — the output is always the five-variant preview.

---

## Checklist before handing off

- [ ] Exactly five variants generated, each a meaningfully distinct design direction
- [ ] Tile containers match correct aspect ratios for chosen `tile_size`
- [ ] Every tile has at least one interactive element (hover, tap, drag, animation)
- [ ] Each tile has a UX callout block (web_ux, mobile_ux, tradeoff) rendered statically
- [ ] Each tile has a "Select this variant" button and `data-variant` attribute
- [ ] `HANDOFFS` JS object present with entries for v1–v5, all fields complete
- [ ] Handoff panel present (`<section id="handoff-panel">`), pre-selected to recommended variant
- [ ] "Copy AGENT_HANDOFF" and "Copy scaffold command" buttons functional
- [ ] `scaffold_command` in every HANDOFFS entry is `dart run tool/new_widget.dart <widget_id>` (no tile_size)
- [ ] `content.json` snippet updates when variant is selected
- [ ] Static `AGENT_HANDOFF` comment present before `</body>` (reflects recommended variant)
- [ ] `description` fields are precise enough to implement from without seeing the HTML
- [ ] `web_ux` and `mobile_ux` are specific to the tile_size, not generic
- [ ] File saved to `skills/bento-widget-preview/outputs/<widget_id>-preview.html`
- [ ] File opens offline — no external CDN imports
- [ ] Footer states: "Prototype only. Implement in Flutter via InteractiveWidget."
