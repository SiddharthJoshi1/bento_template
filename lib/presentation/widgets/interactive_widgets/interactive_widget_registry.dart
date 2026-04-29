import 'interactive_widget.dart';
import 'counter/counter_widget.dart';

/// Static registry mapping widget IDs → factory functions.
///
/// To add your own widget:
/// 1. Create `lib/presentation/widgets/interactive_widgets/your_widget/your_widget.dart`
///    and implement [InteractiveWidget].
/// 2. Import it here and add one line to [_widgets].
///
/// That's it — [SmartBentoTile] resolves everything else automatically.
/// See WIDGET_GUIDE.md for a full walkthrough.
class WidgetRegistry {
  WidgetRegistry._();

  static final Map<String, InteractiveWidget Function()> _widgets = {
    // counter_v1 is a minimal reference implementation — read it alongside
    // WIDGET_GUIDE.md, then replace it with your own widgets.
    'counter_v1': CounterWidget.new,

    // Add your widgets here:
    // 'my_widget_v1': MyWidget.new,
  };

  /// Returns an [InteractiveWidget] instance for [widgetId], or null if not found.
  static InteractiveWidget? getWidget(String widgetId) =>
      _widgets[widgetId]?.call();

  /// All registered widget IDs — useful for dev tooling / debugging.
  static List<String> get allIds => _widgets.keys.toList();
}
