import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/constants.dart';
import '../../../../../domain/entities/tile_config.dart';
import '../../../../utils/app_styles.dart';
import '../../../helpers/pulsing_location_dot.dart';

/// Renders a live OpenStreetMap tile centred on [TileConfig.latitude] /
/// [TileConfig.longitude]. Falls back to a placeholder when coordinates are
/// absent or the network is unavailable.
class MapTileRenderer extends StatefulWidget {
  final TileConfig config;

  const MapTileRenderer({super.key, required this.config});

  @override
  State<MapTileRenderer> createState() => _MapTileRendererState();
}

class _MapTileRendererState extends State<MapTileRenderer> {
  bool _mapReady = false;
  late final MapController _mapController;

  /// Whether this tile has usable coordinates.
  bool get _hasCoords =>
      widget.config.latitude != null && widget.config.longitude != null;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    // Defer FlutterMap initialisation by one frame so tile network requests
    // and layout don't fire during the scroll gesture that reveals this tile.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _mapReady = true);
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCoords) return _buildPlaceholder(context);
    if (!_mapReady) return _buildPlaceholder(context);

    final centre = LatLng(widget.config.latitude!, widget.config.longitude!);

    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: centre,
            initialZoom: MapConstants.defaultZoom,
            minZoom: MapConstants.minZoom,
            maxZoom: MapConstants.maxZoom,
            interactionOptions: InteractionOptions(flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag)
          ),
          children: [
            TileLayer(
              urlTemplate: MapConstants.tileUrlTemplate,
              userAgentPackageName: MapConstants.userAgentPackageName,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: centre,
                  width: 60,
                  height: 60,
                  child: const PulsingLocationDot(),
                ),
              ],
            ),
          ],
        ),
        if (widget.config.title != null && widget.config.title!.isNotEmpty)
          Positioned(
            bottom: AppInsets.s,
            left: AppInsets.s,
            right: AppInsets.s,
            child: _buildLabel(context),
          ),
      ],
    );
  }

  /// Pill label shown over the map with the tile's title.
  Widget _buildLabel(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppInsets.s,
            vertical: AppInsets.xs,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(AppInsets.s),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            widget.config.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ResponsiveText.caption(context)?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  /// Shown when coordinates are missing — keeps the tile non-empty in dev.
  Widget _buildPlaceholder(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: AppColors.mapBackground),
        const Center(
          child: Icon(
            Icons.location_on_outlined,
            color: AppColors.mapPin,
            size: AppIconSizes.xl,
          ),
        ),
        if (widget.config.title != null && widget.config.title!.isNotEmpty)
          Positioned(
            bottom: AppInsets.s,
            left: AppInsets.s,
            right: AppInsets.s,
            child: _buildLabel(context),
          ),
      ],
    );
  }
}

