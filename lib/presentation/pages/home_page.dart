import 'package:bento_template/presentation/utils/app_styles.dart';
import 'package:bento_template/presentation/widgets/theme_controls/theme_controls.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Widget profileWidget;
  final Widget tileSectionWidget;
  const HomePage({
    super.key,
    required this.profileWidget,
    required this.tileSectionWidget,
  });

  Widget buildHomePageWidget(BuildContext context) {
    //normal

    Widget widget = SizedBox.shrink();
    if (Breakpoints.isDesktop(context)) {
      widget = Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(flex: 3, child: profileWidget),
          Expanded(flex: 4, child: tileSectionWidget),
        ],
      );
    } else {
      widget = Align(
        alignment:
            Alignment.topCenter, // Stick to top, but centered horizontally
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: tileSectionWidget,
          ),
        ),
      );
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildHomePageWidget(context),
          const ThemeControls(),
        ],
      ),
    );
  }
}
