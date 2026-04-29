class LinkConfig {
  final String linkTitle;
  final String linkIcon;
  final String brandColour;

  const LinkConfig({
    required this.linkTitle,
    required this.linkIcon,
    required this.brandColour,
  });

  factory LinkConfig.fromJson(Map<String, dynamic> json) => LinkConfig(
        linkTitle: json['link_title'] as String,
        linkIcon: json['link_icon'] as String,
        brandColour: json['brand_colour'] as String,
      );

  /// Used as a safety net if JSON loading fails at startup.
  static const LinkConfig fallback = LinkConfig(
    linkTitle: 'Website',
    linkIcon: 'fa-solid fa-link',
    brandColour: '#000000',
  );
}
