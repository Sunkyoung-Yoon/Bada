import 'package:bada/provider/map_provider.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class LocationUpdater {
  final MapProvider mapProvider;
  late KakaoMapController mapController;
  Set<Marker> markers = {};

  LocationUpdater({required this.mapProvider});

  void setMapController(KakaoMapController controller) {
    mapController = controller;
  }

  Future<void> updateCurrentLocation() async {
    LatLng currentLocation = mapProvider.currentLocation;
    markers.clear();
    markers.add(
      Marker(
        markerId: 'current_location',
        latLng: currentLocation,
        width: 30,
        height: 44,
        offsetX: 15,
        offsetY: 44,
        markerImageSrc:
            'https://w7.pngwing.com/pngs/96/889/png-transparent-marker-map-interesting-places-the-location-on-the-map-the-location-of-the-thumbnail.png',
      ),
    );
  }
}
