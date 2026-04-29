import 'package:flutter/material.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/profile_data.dart';

/// Profile display — adapts its own layout for desktop and mobile.
///
/// Receives [ProfileData] directly from [PortfolioBloc] via [main.dart]
/// rather than reading from GetIt, keeping this widget stateless and testable.
class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key, required this.profile});

  final ProfileData profile;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = Breakpoints.isDesktop(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppInsets.xxl : AppInsets.l,
      ),
      child: Column(
        mainAxisAlignment: isDesktop
            ? MainAxisAlignment.start
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDesktop) const SizedBox(height: 80),
          if (isDesktop)
            CircleAvatar(
              radius: 100,
              backgroundImage: _resolveAvatarImage(profile.avatarPath),
            )
          else
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: _resolveAvatarImage(profile.avatarPath),
              ),
            ),
          const SizedBox(height: 50),
          Text(
            profile.name,
            style: isDesktop
                ? Theme.of(context).textTheme.displayMedium
                : Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
          ),
          const SizedBox(height: 10),
          Text(
            profile.bio,
            softWrap: true,
            style: isDesktop
                ? Theme.of(context).textTheme.titleLarge
                : Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }

  /// Returns a [NetworkImage] for absolute URLs, [AssetImage] for asset paths.
  ImageProvider _resolveAvatarImage(String path) {
    if (path.startsWith('http')) return NetworkImage(path);
    return AssetImage(path);
  }
}
