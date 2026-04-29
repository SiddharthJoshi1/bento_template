# WIDGET_GUIDE.md — Building an interactive widget

Interactive widgets are self-contained Flutter widgets that live inside bento tiles. They're the most expressive part of the template — small, interactive experiments that demonstrate something you couldn't show in a static portfolio.

This guide walks through building one from scratch.

---

## How the system works

There are three moving parts:

1. **`InteractiveWidget`** — an abstract base class every widget implements
2. **`WidgetRegistry`** — a static map from `widget_id` strings to factory functions
3. **`content.json`** — where you declare which widget goes in which tile

`SmartBentoTile` resolves everything automatically. You implement the widget, register it, add a tile — done.

---

## Step 1 — Create your widget file

Create a new folder and file under:

```
lib/presentation/widgets/interactive_widgets/
└── your_widget/
    └── your_widget.dart       # (+ any supporting files)
```

Keeping each widget in its own folder avoids clutter as you add more.

---

## Step 2 — Implement InteractiveWidget

```dart
import 'package:flutter/material.dart';
import '../interactive_widget.dart';

class CounterWidget extends InteractiveWidget {
  const CounterWidget();

  @override
  String get widgetId => 'counter_v1';

  @override
  String get displayName => 'Counter';

  @override
  String get description => 'A simple tap counter. Demonstrates stateful widgets in a tile.';

  @override
  List<String> get tags => ['interactive', 'simple'];

  @override
  Widget buildWithConfig(Map<String, dynamic> config, {String? colour}) {
    final label = config['label'] as String? ?? 'Tap me';
    return _CounterCanvas(label: label);
  }
}

class _CounterCanvas extends StatefulWidget {
  const _CounterCanvas({required this.label});
  final String label;

  @override
  State<_CounterCanvas> createState() => _CounterCanvasState();
}

class _CounterCanvasState extends State<_CounterCanvas> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _count++),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('$_count', style: Theme.of(context).textTheme.displaySmall),
          ],
        ),
      ),
    );
  }
}
```

### Rules to follow

- **Defensive config access** — `config` comes from JSON; keys may be absent or the wrong type. Always cast with `as String?` and provide fallbacks.
- **Stateful UI goes in a private `StatefulWidget`** — keep the `InteractiveWidget` subclass itself stateless (it's instantiated by the registry, not by Flutter's widget tree).
- **Derive colours from the `colour` argument** — don't hardcode dark or light colours. If you need to adapt to the tile's background colour, use the `ColourBrightness` extension in `lib/presentation/extensions/colour_extension.dart`.
- **No DI / GetIt inside widgets** — widgets are self-contained. If you need data, pass it through `widget_config` in JSON.

---

## Step 3 — Register it

Open `lib/presentation/widgets/interactive_widgets/interactive_widget_registry.dart` and add two lines:

```dart
import 'your_widget/your_widget.dart';   // add this import

static final Map<String, InteractiveWidget Function()> _widgets = {
  'spinner_v1': SpinnerWidget.new,
  'counter_v1': CounterWidget.new,       // add this line
};
```

That's the only file outside your widget folder you need to touch.

---

## Step 4 — Add a tile in content.json

Add a tile entry to `assets/data/content.json` (and to your `content` branch):

```json
{
  "type": "widgets",
  "tile_size": "half_card",
  "title": "Counter",
  "widget_id": "counter_v1",
  "widget_config": {
    "label": "Tap me"
  }
}
```

The `widget_config` object is passed directly to `buildWithConfig`. Anything you put here is accessible in your widget — use it for labels, colours, item lists, or any other configuration you want to expose.

---

## Step 5 — Verify

```bash
flutter analyze        # must pass clean
flutter run -d chrome  # check it renders in the grid
```

---

## Tips for good widgets

**Keep them small and focused.** A widget that does one interesting thing is better than one that tries to do many. The tile constrains the space — work with that constraint.

**Version your widget ID.** The convention is `snake_case_v1`. If you change `widget_config` in a breaking way (removing or renaming keys), bump to `v2` so any existing JSON doesn't silently break.

**Separate canvas from widget.** For anything with animation, keep the `AnimationController` and painting logic in a dedicated `_Canvas` widget (see `spinner/spinner_canvas.dart` and `spinner/spinner_painter.dart` for the pattern). This keeps `buildWithConfig` thin and the animation logic easy to find.

**Handle the empty/default state gracefully.** If `widget_config` is omitted entirely in JSON, your widget should still render something sensible using fallback values.

---

## Real example — SpinnerWidget

The spinning wheel widget (`spinner_v1`) is the reference implementation. It's structured as:

```
spinner/
├── spinner_widget.dart    # InteractiveWidget subclass — thin, just wires config
├── spinner_canvas.dart    # StatefulWidget — AnimationController, gesture handling
└── spinner_painter.dart   # CustomPainter — draws the pie slices
```

`spinner_widget.dart` reads `items` and `title` from config and passes them down. All animation state lives in `spinner_canvas.dart`. All drawing logic lives in `spinner_painter.dart`. Nothing leaks between layers.

Follow this pattern for any widget that involves animation or custom painting.
