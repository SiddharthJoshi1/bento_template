import 'package:flutter/material.dart';
import '../interactive_widget.dart';

/// Minimal reference widget — a tap counter.
///
/// This exists to show the full widget pattern end-to-end with the simplest
/// possible implementation. Read this alongside WIDGET_GUIDE.md before
/// building your own widget, then delete or replace it.
///
/// widget_config keys:
///   label  — optional, String, text shown above the count (default: "Taps")
///
/// Example content.json entry:
/// ```json
/// {
///   "type": "widgets",
///   "tile_size": "quarter_card",
///   "title": "Counter",
///   "widget_id": "counter_v1",
///   "widget_config": {
///     "label": "Taps"
///   }
/// }
/// ```
class CounterWidget extends InteractiveWidget {
  const CounterWidget();

  @override
  String get widgetId => 'counter_v1';

  @override
  String get displayName => 'Tap Counter';

  @override
  String get description => 'A minimal stateful counter — the hello world of interactive widgets.';

  @override
  List<String> get tags => ['example', 'stateful', 'reference'];

  @override
  Widget buildWithConfig(Map<String, dynamic> config, {String? colour}) {
    final label = config['label'] as String? ?? 'Taps';
    return _CounterBody(label: label);
  }
}

class _CounterBody extends StatefulWidget {
  const _CounterBody({required this.label});
  final String label;

  @override
  State<_CounterBody> createState() => _CounterBodyState();
}

class _CounterBodyState extends State<_CounterBody> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _count++),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_count',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
