import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/geolocation_provider.dart';
import '../controllers/navigation_target_provider.dart';
import '../controllers/map_cache_provider.dart';
import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/navigation_target_entity.dart';

class NavigationMap extends ConsumerStatefulWidget {
  const NavigationMap({super.key});

  @override
  ConsumerState<NavigationMap> createState() => _NavigationMapState();
}

class _NavigationMapState extends ConsumerState<NavigationMap> {
  final MapController _mapController = MapController();
  bool _hasInitiallyCentered = false;
  bool _showOfflineNotice = true;

  @override
  Widget build(BuildContext context) {
    final cacheStoreAsync = ref.watch(mapCacheStoreProvider);

    // 1. ESCUTA PARA CÂMERA
    ref.listen<AsyncValue<LocationEntity>>(geolocationStreamProvider, (
      previous,
      next,
    ) {
      if (!_hasInitiallyCentered) {
        final loc = next.value;
        if (loc != null) {
          _hasInitiallyCentered = true;
          final target = ref.read(navigationTargetProvider).value;
          _moveToFit(loc, target);
        }
      }
    });

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FlutterMap(
            mapController: _mapController,
            options: const MapOptions(),
            children: [
              cacheStoreAsync.when(
                data: (cacheStore) => TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.mirai',
                  tileProvider: CachedTileProvider(store: cacheStore),
                ),
                loading: () => TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.mirai',
                ),
                error: (_, __) => TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.mirai',
                ),
              ),

              // 3. CAMADA DE MARCADORES
              Consumer(
                builder: (context, ref, child) {
                  final loc = ref.watch(geolocationStreamProvider).value;
                  final target = ref.watch(navigationTargetProvider).value;

                  final markers = <Marker>[];

                  if (target != null) {
                    markers.add(
                      Marker(
                        point: LatLng(target.latitude, target.longitude),
                        width: 48,
                        height: 48,
                        child: const Icon(
                          Icons.location_on,
                          key: ValueKey('target_icon'),
                          color: Colors.red,
                          size: 36,
                        ),
                      ),
                    );
                  }

                  if (loc != null) {
                    markers.add(
                      Marker(
                        point: LatLng(loc.latitude, loc.longitude),
                        width: 36,
                        height: 36,
                        child: const Icon(
                          Icons.my_location,
                          key: ValueKey('user_icon'),
                          color: Colors.blue,
                          size: 28,
                        ),
                      ),
                    );
                  }

                  return MarkerLayer(markers: markers);
                },
              ),
            ],
          ),
        ),
        if (_showOfflineNotice)
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_download, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'O mapa será salvo automaticamente para uso offline.',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _showOfflineNotice = false),
                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _moveToFit(LocationEntity? loc, NavigationTargetEntity? target) {
    try {
      if (loc != null && target != null) {
        final center = LatLng(
          (loc.latitude + target.latitude) / 2,
          (loc.longitude + target.longitude) / 2,
        );
        _mapController.move(center, 14);
      } else if (loc != null) {
        final center = LatLng(loc.latitude, loc.longitude);
        _mapController.move(center, 16);
      }
    } catch (_) {
      // Ignora erro se o controlador não estiver 100% acoplado no primeiro milissegundo
    }
  }
}
