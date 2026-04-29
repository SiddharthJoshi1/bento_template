import 'package:flutter/material.dart';

import '../../../../../domain/entities/tile_config.dart';
import '../../../../../presentation/utils/app_styles.dart';
import '../../../interactive_widgets/interactive_widget_registry.dart';

/// Resolves an [InteractiveWidget] from [WidgetRegistry] using [TileConfig.widgetId]
/// and delegates rendering to [InteractiveWidget.buildWithConfig].
///
/// Renders a branded error state when:
///  - [TileConfig.widgetId] is null or empty
///  - The widgetId is not registered in [WidgetRegistry]
class InteractiveWidgetsTileRenderer extends StatelessWidget {
  final TileConfig config;

  const InteractiveWidgetsTileRenderer({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final id = config.widgetId;

    if (id == null || id.isEmpty) {
      return _buildError(context, 'No widget_id specified');
    }

    final widget = WidgetRegistry.getWidget(id);

    if (widget == null) {
      return _buildError(context, 'Unknown widget: $id');
    }

    return widget.buildWithConfig(config.widgetConfig ?? {}, colour: config.colour);
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppInsets.m),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.widgets_outlined,
                size: AppIconSizes.xl, color: Colors.black26),
            const SizedBox(height: 8),
            Text(
              message,
              style: ResponsiveText.caption(context)
                  ?.copyWith(color: Colors.black38),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
