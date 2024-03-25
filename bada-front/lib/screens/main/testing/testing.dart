import 'package:bada/provider/map_provider.dart';
import 'package:bada/screens/main/testing/location_updater.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class Test extends StatefulWidget {
  const Test({super.key, this.title});

  final String? title;

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late MapProvider mapProvider;
  late KakaoMapController mapController;
  late LocationUpdater locationUpdater;
  late LatLng currentLocation;

  @override
  void initState() {
    super.initState();
    mapProvider = MapProvider(); // MapProvider 인스턴스 생성
    currentLocation = LatLng(33.450701, 126.570667); // 기본 위치 설정
    locationUpdater = LocationUpdater(mapProvider: mapProvider);

    mapProvider.addListener(() async {
      await locationUpdater.updateCurrentLocation(); // 위치 업데이트
    });
  }

  // 현재 위치로 지도를 이동시키는 메소드
  void moveToCurrentLocation() async {
    currentLocation = mapProvider.currentLocation; // 현재 위치를 가져옴
    await mapController.setCenter(currentLocation); // 현재 위치로 지도 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '현재 위치'),
      ),
      body: Stack(
        children: [
          KakaoMap(
            onMapCreated: (controller) {
              mapController = controller;
              locationUpdater.setMapController(controller); // MapController 설정
            },
            markers: locationUpdater.markers.toList(),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () => moveToCurrentLocation,
                  color: Colors.white,
                  child: const Text("setCenter"),
                ),
                const SizedBox(width: 8),
                MaterialButton(
                  onPressed: () => mapController.panTo(currentLocation),
                  color: Colors.white,
                  child: const Text("panTo"),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: moveToCurrentLocation, // 현재 위치로 이동하는 버튼 클릭 시
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
