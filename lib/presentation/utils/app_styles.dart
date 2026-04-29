/// app_styles.dart — compatibility re-export shim.
///
/// Design tokens have moved to:
///   - lib/presentation/theme/app_theme.dart  (AppInsets, AppIconSizes, AppRadii, AppColors, AppTheme)
///   - lib/core/responsive/breakpoints.dart   (Breakpoints, ResponsiveText, ResponsiveBuilder)
///
/// This file re-exports everything so existing imports compile without changes.
/// New code should import from the above locations directly.
library;

export 'package:bento_template/core/responsive/breakpoints.dart'
    show Breakpoints, ResponsiveBuilder, ResponsiveText;

export 'package:bento_template/core/theme/app_theme.dart'
    show AppInsets, AppIconSizes, AppRadii, AppColors, AppTheme;

