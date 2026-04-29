part of 'theme_cubit.dart';


/// Immutable state for [ThemeCubit].
class ThemeState {
  const ThemeState({
    this.mode = ThemeMode.light,
    this.flavourId = 'chalk',
  });

  /// Current brightness mode.
  final ThemeMode mode;

  /// ID of the active [ThemeFlavour]. The same flavour is used for both
  /// light and dark mode — toggling the mode switches between its two variants.
  final String flavourId;

  /// The active [ThemeFlavour] object.
  ThemeFlavour get flavour => ThemeFlavours.byId(flavourId);

  /// The [ThemeVariant] for the current [mode].
  ThemeVariant get activeVariant => flavour.variantFor(mode);

  ThemeState copyWith({
    ThemeMode? mode,
    String? flavourId,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      flavourId: flavourId ?? this.flavourId,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ThemeState &&
      other.mode == mode &&
      other.flavourId == flavourId;

  @override
  int get hashCode => Object.hash(mode, flavourId);
}
