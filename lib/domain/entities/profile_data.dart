/// Holds the personal profile data shown in [ProfileSection] and
/// [MobileProfileHeader].
///
/// Loaded once at startup from `assets/data/content.json` and served
/// synchronously via [ProfileRepository].
class ProfileData {
  const ProfileData({
    required this.name,
    required this.bio,
    required this.avatarPath,
  });

  final String name;
  final String bio;

  /// Asset path to the avatar image e.g. `'assets/Sid Gen.png'`.
  final String avatarPath;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        name: json['name'] as String,
        bio: json['bio'] as String,
        avatarPath: json['avatar_path'] as String,
      );

  /// Empty stub used before [PortfolioBloc] has loaded real content.
  factory ProfileData.empty() => const ProfileData(
        name: '',
        bio: '',
        avatarPath: '',
      );
}
