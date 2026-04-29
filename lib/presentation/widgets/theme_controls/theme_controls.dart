import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/theme/theme_cubit.dart';
import 'control_pill.dart';
import 'theme_panel.dart';

/// Floating theme controls overlay.
///
/// Orchestrates the [ControlPill] and [ThemePanel] with open/close animation.
/// Wraps its content in [SafeArea] so the pill always clears the status bar,
/// notch, and Dynamic Island on any device — no hardcoded insets needed.
///
/// Drop into a [Stack] at the top of the page — no other setup needed.
///
/// ```dart
/// Stack(
///   children: [
///     buildContent(),
///     const ThemeControls(),
///   ],
/// )
/// ```
class ThemeControls extends StatefulWidget {
  const ThemeControls({super.key});

  @override
  State<ThemeControls> createState() => _ThemeControlsState();
}

class _ThemeControlsState extends State<ThemeControls>
    with SingleTickerProviderStateMixin {
  bool _panelOpen = false;
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0.05, -0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _togglePanel() {
    setState(() => _panelOpen = !_panelOpen);
    _panelOpen ? _anim.forward() : _anim.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final cubit = context.read<ThemeCubit>();

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ControlPill(
                  isDark: state.mode == ThemeMode.dark,
                  activeFlavour: state.flavour,
                  activeMode: state.mode,
                  onToggle: cubit.toggleTheme,
                  onPickerTap: _togglePanel,
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: _panelOpen
                        ? ThemePanel(
                            activeId: state.flavourId,
                            activeMode: state.mode,
                            onFlavourSelected: (f) {
                              cubit.setFlavour(f);
                              _togglePanel();
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
