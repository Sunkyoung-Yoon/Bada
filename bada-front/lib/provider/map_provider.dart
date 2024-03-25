import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class MapProvider with ChangeNotifier {
  late final KakaoMapController mapController;
  Timer? _locationUpdateTimer;
  LatLng _currentLocation = LatLng(0, 0); // 초기값은 임의로 설정
  bool _isLocationServiceEnabled = false;

  MapProvider() {
    setCurrentLocation();
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setCurrentLocation();
    });
  }

  // 현재 위치 정보에 대한 getter
  LatLng get currentLocation => _currentLocation;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;

  Future<void> setCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 위치 서비스 활성화 여부 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('위치 서비스가 비활성화되어 있습니다.');
    }

    // 위치 권한 확인 및 요청
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('위치 정보 접근 권한이 거부되었습니다.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('위치 정보 접근 권한이 영구적으로 거부되었습니다.');
    }

    // 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _currentLocation = LatLng(position.latitude, position.longitude);
    _isLocationServiceEnabled = true;

    notifyListeners(); // 위치 정보가 업데이트되면 리스너에게 알림
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel(); // Timer를 취소합니다.
    super.dispose();
  }
}
