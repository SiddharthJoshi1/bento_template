import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LinkIconMapping {
  /// Maps the FontAwesome class string (from the Entity) to the Flutter IconData
  static IconData getIcon(String iconString) {
    return _iconMap[iconString] ?? FontAwesomeIcons.link;
  }

  static const Map<String, IconData> _iconMap = {
    // Brands
    'fa-brands fa-instagram': FontAwesomeIcons.instagram,
    'fa-brands fa-facebook': FontAwesomeIcons.facebook,
    'fa-brands fa-twitter': FontAwesomeIcons.twitter,
    'fa-brands fa-x-twitter': FontAwesomeIcons.xTwitter, // For X.com
    'fa-brands fa-tiktok': FontAwesomeIcons.tiktok,
    'fa-brands fa-youtube': FontAwesomeIcons.youtube,
    'fa-brands fa-linkedin': FontAwesomeIcons.linkedin,
    'fa-brands fa-snapchat': FontAwesomeIcons.snapchat,
    'fa-brands fa-pinterest': FontAwesomeIcons.pinterest,
    'fa-brands fa-spotify': FontAwesomeIcons.spotify,
    'fa-brands fa-apple': FontAwesomeIcons.apple,
    'fa-brands fa-soundcloud': FontAwesomeIcons.soundcloud,
    'fa-brands fa-twitch': FontAwesomeIcons.twitch,
    'fa-brands fa-discord': FontAwesomeIcons.discord,
    'fa-brands fa-reddit': FontAwesomeIcons.reddit,
    'fa-brands fa-whatsapp': FontAwesomeIcons.whatsapp,
    'fa-brands fa-telegram': FontAwesomeIcons.telegram,
    'fa-brands fa-patreon': FontAwesomeIcons.patreon,
    'fa-brands fa-github': FontAwesomeIcons.github,
    'fa-brands fa-medium': FontAwesomeIcons.medium,
    'fa-brands fa-behance': FontAwesomeIcons.behance,
    'fa-brands fa-dribbble': FontAwesomeIcons.dribbble,
    'fa-brands fa-threads': FontAwesomeIcons.threads,
    'fa-brands fa-substack': FontAwesomeIcons.bookOpenReader,

    // Solids / Defaults
    'fa-solid fa-link': FontAwesomeIcons.link,
    'fa-solid fa-envelope': FontAwesomeIcons.envelope,
    'fa-solid fa-globe': FontAwesomeIcons.globe,
  };
}
