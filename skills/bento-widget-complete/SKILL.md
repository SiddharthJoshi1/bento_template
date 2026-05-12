# SKILL: bento-widget-complete

## Purpose

Complete a scaffolded `InteractiveWidget` implementation in Flutter.
This skill is the second half of the widget pipeline — the scaffold CLI stamps
the files, this skill fills them with real logic.

---

## Prerequisites

Before invoking this skill:

1. An HTML preview file exists at `skills/bento-widget-preview/outputs/<widget_id>-preview.html`
   containing an `AGENT_HANDOFF` block.
2. The scaffold CLI has been run:
   ```bash
   dart run tool/new_widget.dart <widget_id>
   ```
3. The following stub files exist:
   ```
   lib/presentation/widgets/interactive_widgets/<widget_id>/
     <widget_id>_widget.dart
     <widget_id>_canvas.dart
     <widget_id>_painter.dart
   ```
4. `interactive_widget_registry.dart` contains the import and registry entry.
5. `assets/data/content.json` contains a tile entry for this widget_id.

---

## AGENT_HANDOFF schema

The HTML preview file contains a block in this exact format:

```
<!-- AGENT_HANDOFF
widget_id: <snake_case_v1>
variant: <chosen variant name>
tile_size: <tile_size>
display_name: <Human Readable Name>
description: <one paragraph describing the interaction model precisely>
painter_needed: true | false
config_schema:
  <key>: <type> (<constraints, default>)
  <key>: <type> (<constraints, default>)
suggested_widget_config:
  <key>: <value>
  <key>: <value>
END_HANDOFF -->
```

Parse this block first. It is the authoritative source for what to implement.

---

## Step 1 — Read context

Before writing any code, read these files in order:

1. The `AGENT_HANDOFF` block from the HTML preview file
2. `WIDGET_GUIDE.md` — implementation rules and patterns
3. `CLAUDE.md` — layer rules and key invariants
4. The scaffold stubs:
   - `<widget_id>_widget.dart`
   - `<widget_id>_canvas.dart`
   - `<widget_id>_painter.dart`
5. `lib/presentation/widgets/interactive_widgets/counter/counter_widget.dart`
   — reference implementation for simple widgets
6. `lib/presentation/extensions/colour_extension.dart`
   — for deriving text colour from tile background

Do not start writing code until you have read all six.

---

## Step 2 — Implement `_widget.dart`

Replace all `TODO` comments. The widget file must:

- Extract every key listed in `config_schema` from the `config` map
- Use defensive casting with fallbacks (`config['key'] as Type? ?? defaultValue`)
- Pass extracted values as typed parameters to the canvas constructor
- Fill in `description` and `tags` from the `AGENT_HANDOFF`

The widget file must stay thin — no state, no animation, no drawing.

---

## Step 3 — Implement `_canvas.dart`

Replace all `TODO` comments. The canvas file must:

- Declare typed fields for every config value passed from the widget
- Set up `AnimationController` with correct duration and repeat behaviour
  derived from the `AGENT_HANDOFF` interaction model
- Wire gesture detectors (`GestureDetector`, `Listener`, or `MouseRegion`)
  that match the `interaction_model` in the handoff
- Pass all relevant state (animation value, gesture position, config fields)
  to the painter via its constructor
- Never contain drawing logic — that belongs in the painter

### AnimationController patterns

| Interaction | Controller behaviour |
|---|---|
| Looping animation | `repeat()` in `initState` |
| Triggered on tap | `forward()` then `reverse()` on gesture |
| Drag-controlled | No controller needed — use raw gesture state |
| Idle with hover | `forward()` on hover enter, `reverse()` on exit |

---

## Step 4 — Implement `_painter.dart`

Replace all `TODO` comments. The painter must:

- Accept all visual state as constructor parameters — never read from external state
- Implement `paint(Canvas canvas, Size size)` fully
- Use `size.width` and `size.height` for all positioning — never hardcode pixel values
- Implement `shouldRepaint` precisely — compare every field that affects rendering

### Drawing guidelines

- Use `canvas.drawArc`, `canvas.drawCircle`, `canvas.drawPath` etc as appropriate
- Derive colours from the `colour` parameter via `ColourExtension` where needed
- Do not import anything from `data/` or `core/` — painter is pure presentation

---

## Step 5 — Update `content.json` widget_config

The CLI wrote an empty `widget_config: {}` to `content.json`.
Replace it with the `suggested_widget_config` values from the `AGENT_HANDOFF` block.

---

## Step 6 — Verify

Run:
```bash
flutter analyze
```

Must exit with zero issues. Fix any analysis errors before handing off.
Do not run `flutter run` — the user will launch the app to verify visually.

---

## Rules

- `presentation` never imports from `data` — enforce strictly
- No `GetIt` / service locator inside widget files
- No hardcoded colours — derive from `colour` param or theme
- No hardcoded pixel values in the painter — always relative to `size`
- `shouldRepaint` must be precise — never return `true` unconditionally
- Config keys must match `config_schema` exactly — no invented keys

---

## Handoff message

When complete, output this summary to the user:

```
✓ <widget_id> implementation complete.

Files updated:
  lib/presentation/widgets/interactive_widgets/<widget_id>/<widget_id>_widget.dart
  lib/presentation/widgets/interactive_widgets/<widget_id>/<widget_id>_canvas.dart
  lib/presentation/widgets/interactive_widgets/<widget_id>/<widget_id>_painter.dart
  assets/data/content.json

flutter analyze: passed

Next: flutter run -d chrome and check the tile renders correctly.
If the tile is missing, verify widget_id matches the registry entry.
```
