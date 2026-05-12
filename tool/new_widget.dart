// tool/new_widget.dart
//
// Bento widget scaffold CLI.
// Stamps boilerplate files for a new InteractiveWidget, wires the registry,
// and adds a tile entry to content.json.
//
// Usage:
//   dart run tool/new_widget.dart <widget_id>
//
// Example:
//   dart run tool/new_widget.dart mood_tracker_v1
//
// Arguments:
//   widget_id   — snake_case_v1 identifier, must be unique in WidgetRegistry
//
// tile_size is always scaffolded as half_tower. The bento-widget-complete
// skill overwrites it with the correct value from the AGENT_HANDOFF.
//
// What this creates:
//   lib/presentation/widgets/interactive_widgets/<widget_id>/
//     <widget_id>_widget.dart    — InteractiveWidget subclass stub
//     <widget_id>_canvas.dart    — StatefulWidget canvas stub
//     <widget_id>_painter.dart   — CustomPainter stub
//
// What this wires:
//   lib/presentation/widgets/interactive_widgets/interactive_widget_registry.dart
//     — import + registry entry added
//
//   assets/data/content.json
//     — tile entry appended to the "tiles" array
//
// After running:
//   Hand the generated stubs + the AGENT_HANDOFF block from your HTML preview
//   to the bento-widget-complete skill to fill in the implementation.
//   Then run: flutter analyze

import 'dart:io';

const _scaffoldTileSize = 'half_tower';

void main(List<String> args) {
  // ── Validate args ──────────────────────────────────────────────────────────
  if (args.isEmpty || args.length > 1) {
    _exit(
      'Usage: dart run tool/new_widget.dart <widget_id>\n'
      'Example: dart run tool/new_widget.dart mood_tracker_v1',
    );
  }

  final widgetId = args[0].trim();

  if (!RegExp(r'^[a-z][a-z0-9_]*_v\d+$').hasMatch(widgetId)) {
    _exit(
      'Invalid widget_id "$widgetId".\n'
      'Must be snake_case ending in _v<number>, e.g. mood_tracker_v1',
    );
  }

  // ── Derive names ───────────────────────────────────────────────────────────
  // mood_tracker_v1 → MoodTrackerV1
  final className = _toPascalCase(widgetId);
  // mood_tracker_v1 → Mood Tracker
  final displayName = _toDisplayName(widgetId);

  // ── Paths ──────────────────────────────────────────────────────────────────
  final widgetDir = 'lib/presentation/widgets/interactive_widgets/$widgetId';
  final widgetFile = '$widgetDir/${widgetId}_widget.dart';
  final canvasFile = '$widgetDir/${widgetId}_canvas.dart';
  final painterFile = '$widgetDir/${widgetId}_painter.dart';
  final registryFile =
      'lib/presentation/widgets/interactive_widgets/interactive_widget_registry.dart';
  final contentFile = 'assets/data/content.json';

  // ── Guard: widget_id must not already exist ────────────────────────────────
  if (Directory(widgetDir).existsSync()) {
    _exit('Directory "$widgetDir" already exists. Aborting to avoid overwrite.');
  }

  // ── Create widget directory ────────────────────────────────────────────────
  Directory(widgetDir).createSync(recursive: true);
  _log('Created $widgetDir/');

  // ── Write _widget.dart ─────────────────────────────────────────────────────
  File(widgetFile).writeAsStringSync(_widgetTemplate(
    widgetId: widgetId,
    className: className,
    displayName: displayName,
  ));
  _log('Created $widgetFile');

  // ── Write _canvas.dart ─────────────────────────────────────────────────────
  File(canvasFile).writeAsStringSync(_canvasTemplate(
    widgetId: widgetId,
    className: className,
  ));
  _log('Created $canvasFile');

  // ── Write _painter.dart ────────────────────────────────────────────────────
  File(painterFile).writeAsStringSync(_painterTemplate(
    widgetId: widgetId,
    className: className,
  ));
  _log('Created $painterFile');

  // ── Wire registry ──────────────────────────────────────────────────────────
  _wireRegistry(
    registryFile: registryFile,
    widgetId: widgetId,
    className: className,
  );

  // ── Add content.json tile ──────────────────────────────────────────────────
  _addContentTile(
    contentFile: contentFile,
    widgetId: widgetId,
    displayName: displayName,
  );

  // ── Done ───────────────────────────────────────────────────────────────────
  _logSuccess(widgetId: widgetId, widgetDir: widgetDir);
}

// ── Registry wiring ──────────────────────────────────────────────────────────

void _wireRegistry({
  required String registryFile,
  required String widgetId,
  required String className,
}) {
  final file = File(registryFile);
  if (!file.existsSync()) {
    _exit('Registry file not found: $registryFile');
  }

  var content = file.readAsStringSync();

  // Add import after last existing import
  final importLine = "import '$widgetId/${widgetId}_widget.dart';";

  if (content.contains(importLine)) {
    _log('Import already present in registry — skipping');
  } else {
    final lastImportIndex =
        content.lastIndexOf(RegExp(r"^import '.*';", multiLine: true));
    if (lastImportIndex == -1) {
      _exit('Could not find import block in registry file.');
    }
    final insertAt = content.indexOf('\n', lastImportIndex) + 1;
    content =
        '${content.substring(0, insertAt)}$importLine\n${content.substring(insertAt)}';
  }

  // Add registry entry after the comment "// Add your widgets here:"
  final registryEntry = "    '$widgetId': ${className}Widget.new,";

  if (content.contains(registryEntry)) {
    _log('Registry entry already present — skipping');
  } else {
    const marker = '// Add your widgets here:';
    if (!content.contains(marker)) {
      _exit('Could not find "$marker" comment in registry file.');
    }
    content = content.replaceFirst(
      marker,
      '$marker\n$registryEntry',
    );
  }

  file.writeAsStringSync(content);
  _log('Updated $registryFile');
}

// ── content.json wiring ───────────────────────────────────────────────────────

void _addContentTile({
  required String contentFile,
  required String widgetId,
  required String displayName,
}) {
  final file = File(contentFile);
  if (!file.existsSync()) {
    _exit('content.json not found: $contentFile');
  }

  var content = file.readAsStringSync();

  // Check not already present
  if (content.contains('"widget_id": "$widgetId"')) {
    _log('content.json already contains $widgetId — skipping');
    return;
  }

  // tile_size is a placeholder — bento-widget-complete overwrites it from AGENT_HANDOFF
  final newTile = '''  ,{
    "type": "widgets",
    "tile_size": "$_scaffoldTileSize",
    "title": "$displayName",
    "widget_id": "$widgetId",
    "widget_config": {}
  }''';

  // Insert before the closing ] of the tiles array
  final insertPoint = content.lastIndexOf(']');
  if (insertPoint == -1) {
    _exit('Could not find closing ] in content.json');
  }

  content =
      '${content.substring(0, insertPoint)}\n$newTile\n${content.substring(insertPoint)}';

  file.writeAsStringSync(content);
  _log('Updated $contentFile');
}

// ── Templates ────────────────────────────────────────────────────────────────

String _widgetTemplate({
  required String widgetId,
  required String className,
  required String displayName,
}) =>
    '''import 'package:flutter/material.dart';
import '../interactive_widget.dart';
import '${widgetId}_canvas.dart';

// TODO: Fill in description, tags, and wire config keys from AGENT_HANDOFF.
class ${className}Widget extends InteractiveWidget {
  const ${className}Widget();

  @override
  String get widgetId => '$widgetId';

  @override
  String get displayName => '$displayName';

  @override
  String get description => 'TODO: describe what this widget does.';

  @override
  List<String> get tags => ['todo'];

  @override
  Widget buildWithConfig(Map<String, dynamic> config, {String? colour}) {
    // TODO: Extract config keys from AGENT_HANDOFF config_schema and pass to canvas.
    return ${className}Canvas(config: config, colour: colour);
  }
}
''';

String _canvasTemplate({
  required String widgetId,
  required String className,
}) =>
    '''import 'package:flutter/material.dart';
import '${widgetId}_painter.dart';

// TODO: Implement interaction and animation logic from AGENT_HANDOFF description.
// Pattern: keep AnimationController here, all drawing in ${className}Painter.
class ${className}Canvas extends StatefulWidget {
  const ${className}Canvas({super.key, required this.config, this.colour});

  final Map<String, dynamic> config;
  final String? colour;

  @override
  State<${className}Canvas> createState() => _${className}CanvasState();
}

class _${className}CanvasState extends State<${className}Canvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // TODO: Configure duration and behaviour from AGENT_HANDOFF.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Wire gesture detectors and pass state to CustomPaint.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: ${className}Painter(
            progress: _controller.value,
            // TODO: pass config-derived fields.
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}
''';

String _painterTemplate({
  required String widgetId,
  required String className,
}) =>
    '''import 'package:flutter/material.dart';

// TODO: Implement drawing logic from AGENT_HANDOFF description.
// All rendering lives here — keep canvas stateless.
class ${className}Painter extends CustomPainter {
  const ${className}Painter({
    required this.progress,
    // TODO: add config-derived fields as constructor params.
  });

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement painting.
  }

  @override
  bool shouldRepaint(${className}Painter oldDelegate) =>
      oldDelegate.progress != progress;
}
''';

// ── Helpers ───────────────────────────────────────────────────────────────────

// mood_tracker_v1 → MoodTrackerV1
String _toPascalCase(String input) {
  return input
      .split('_')
      .map((word) =>
          word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
      .join();
}

// mood_tracker_v1 → Mood Tracker (strips _v1 suffix)
String _toDisplayName(String input) {
  final withoutVersion = input.replaceAll(RegExp(r'_v\d+$'), '');
  return withoutVersion
      .split('_')
      .map((word) =>
          word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

void _log(String message) => stdout.writeln('  ✓ $message');

void _logSuccess({
  required String widgetId,
  required String widgetDir,
}) {
  stdout.writeln('');
  stdout.writeln('────────────────────────────────────────');
  stdout.writeln('  Widget scaffold created: $widgetId');
  stdout.writeln('────────────────────────────────────────');
  stdout.writeln('');
  stdout.writeln('  Files created:');
  stdout.writeln('    $widgetDir/${widgetId}_widget.dart');
  stdout.writeln('    $widgetDir/${widgetId}_canvas.dart');
  stdout.writeln('    $widgetDir/${widgetId}_painter.dart');
  stdout.writeln('');
  stdout.writeln('  Next steps:');
  stdout.writeln('    1. Hand the stubs + AGENT_HANDOFF block to the');
  stdout.writeln('       bento-widget-complete skill in Claude Code.');
  stdout.writeln('    2. Review the implementation.');
  stdout.writeln('    3. Run: flutter analyze');
  stdout.writeln('    4. Launch the app and check the tile renders.');
  stdout.writeln('');
}

Never _exit(String message) {
  stderr.writeln('\n  ✗ Error: $message\n');
  exit(1);
}
