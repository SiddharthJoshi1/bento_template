# bento-widget-preview — Sample Prompts

Copy and paste these into a new agent session to generate widget preview HTML files.
Always reference `skills/bento-widget-preview/SKILL.md` at the start of the session.
All outputs are saved to `skills/bento-widget-preview/outputs/`.

---

## Single mode — focused widget exploration

```
Read skills/bento-widget-preview/SKILL.md first.

Using the bento-widget-preview skill, generate a single-mode HTML preview of a clock widget
that shows the current time with a minimal circular face. Show seconds ticking live.
Use half_card tile size. Include a copy button for widget_config JSON.
Save to skills/bento-widget-preview/outputs/clock_v1-preview-single.html.
```

---

```
Read skills/bento-widget-preview/SKILL.md first.

Using the bento-widget-preview skill, generate a single-mode HTML preview of a GitHub
contribution graph widget — a heatmap of daily activity for the last 12 weeks.
Use full_card tile size. Include a slider to control the colour intensity.
Save to skills/bento-widget-preview/outputs/github_heatmap_v1-preview-single.html.
```

---

```
Read skills/bento-widget-preview/SKILL.md first.

Using the bento-widget-preview skill, generate a single-mode HTML preview of a particle
animation widget. Include sliders for: particle count (10–200), speed (slow/fast),
and a colour picker. Show the current config values and include a copy button.
Use half_tower tile size.
Save to skills/bento-widget-preview/outputs/particle_v1-preview-single.html.
```

---

## Grid mode — comparing directions

```
Read skills/bento-widget-preview/SKILL.md first.

Using the bento-widget-preview skill, generate a grid-mode HTML preview comparing
4 different approaches to a word-count / writing streak tracker widget.
Vary the visual treatment: progress ring, bar chart, calendar grid, and large number.
Use half_card for all 4. Label each with the tradeoff it makes.
Save to skills/bento-widget-preview/outputs/writing_streak_v1-preview-grid.html.
```

---

```
Read skills/bento-widget-preview/SKILL.md first.

Using the bento-widget-preview skill, generate a grid-mode HTML preview comparing
3 approaches to a "now playing" music widget. Vary the layout: album art focus,
waveform visualiser, and minimal text-only. Use half_card for all.
Save to skills/bento-widget-preview/outputs/now_playing_v1-preview-grid.html.
```

---

```
Read skills/bento-widget-preview/SKILL.md first.

Using the bento-widget-preview skill, generate a grid-mode HTML preview comparing
6 different visual approaches to displaying a live visitor count on a portfolio.
Use quarter_card for all 6 — the tight constraint is intentional.
Label each with what it communicates and what it sacrifices.
Save to skills/bento-widget-preview/outputs/visitor_count_v1-preview-grid.html.
```

---

## With interactive config tuning

```
Read skills/bento-widget-preview/SKILL.md first.

Using the bento-widget-preview skill, generate a single-mode preview of a spinning
decision wheel widget (like the Tonight I Should... spinner). Include controls for:
number of segments (3–8), and an editable list of labels. Show the wheel spinning
on click. Add a copy button that exports the current config as widget_config JSON.
Use half_card tile size.
Save to skills/bento-widget-preview/outputs/spinner_v1-preview-single.html.
```

---

```
Read skills/bento-widget-preview/SKILL.md first.

Using the bento-widget-preview skill, generate a single-mode preview of a typing
speed / WPM widget — shows a short text prompt, times the user typing it,
displays WPM at the end. Include controls for: text prompt (editable),
target WPM (slider). Use half_tower tile size.
Save to skills/bento-widget-preview/outputs/typing_speed_v1-preview-single.html.
```

---

## Notes

- Always open output HTML directly in a browser — no server needed
- The `content.json` snippet at the bottom of each file is ready to paste into `assets/data/content.json`
- Once you've found the direction you want, use the preview as the spec when implementing the real `InteractiveWidget` in Flutter
- Follow the widget implementation steps in `WIDGET_GUIDE.md`
