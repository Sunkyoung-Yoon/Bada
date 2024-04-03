import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bada/provider/profile_provider.dart';
import 'package:bada/screens/main/my_family/model/current_location.dart';
import 'package:bada/screens/main/my_family/model/route_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class ExistingPathMap extends StatefulWidget {
  final int memberId;

  const ExistingPathMap({
    super.key,
    required this.memberId,
  });

  @override
  State<ExistingPathMap> createState() => _ExistingPathMapState();
}

// TODO : 경로 삭제 버튼 추가
class _ExistingPathMapState extends State<ExistingPathMap> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late KakaoMapController mapController;
  Future<List>? myPlaces;
  List<LatLng> pathPoints = []; // 경로 포인트 리스트
  Set<Marker> markers = {}; // 마커 변수
  Set<Polyline> polylines = {}; // 폴리라인 변수
  LatLng? middle;
  Future<bool>? _loadPath;
  String? placeName;
  String? addressName;
  String? childName;
  String? childProfileUrl;
  LatLng? currentLocation;
  LatLng? departure;
  LatLng? destination;
  double? verticalForLevel;
  double? horizontalForLevel;

  // 경로 찾기 + 현재 위치 찾기
  Future<bool> _loadExistingPath() async {
    return await _requestCurrentLocation() && await _requestPath();
  }

  // 현재 위치 요청
  Future<bool> _requestCurrentLocation() async {
    var accessToken = await secureStorage.read(key: 'accessToken');
    try {
      final uri = Uri.parse(
        'https://j10b207.p.ssafy.io/api/currentLocation/${widget.memberId}',
      );
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        CurrentLocation responseCurrentLocation =
            CurrentLocation.fromJson(jsonData);
        setState(() {
          currentLocation = LatLng(
            responseCurrentLocation.currentLatitude,
            responseCurrentLocation.currentLongitude,
          );
          childName = responseCurrentLocation.childName;
          childProfileUrl = responseCurrentLocation.childProfileUrl;
        });
        return true;
      } else {
        debugPrint('현재 위치를 가져오는 데 실패했습니다.');
        return false;
      }
    } catch (e) {
      debugPrint('현재 위치를 가져오는 데 실패했습니다.');
      return false;
    }
  }

  // 경로 정보 요청
  Future<bool> _requestPath() async {
    debugPrint('멤버 아이디: ${widget.memberId}');

    var accessToken = await secureStorage.read(key: 'accessToken');
    if (accessToken == null) {
      debugPrint('Access Token이 존재하지 않습니다.');
      throw Exception('Access Token이 필요합니다.');
    }

    var url =
        Uri.parse('https://j10b207.p.ssafy.io/api/route/${widget.memberId}');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      RouteInfo routeInfo = RouteInfo.fromJson(jsonData);
      // 시작점 추가
      pathPoints.add(LatLng(routeInfo.startLat, routeInfo.startLng));

      List<Point> pointList = routeInfo.pointList;
      for (var point in pointList) {
        double lat = point.latitude;
        double lng = point.longitude;
        pathPoints.add(LatLng(lat, lng));
      }

      // 종점 추가
      pathPoints.add(LatLng(routeInfo.endLat, routeInfo.endLng));

      setState(() {
        departure = LatLng(routeInfo.startLat, routeInfo.startLng);
        destination = LatLng(routeInfo.endLat, routeInfo.endLng);
        middle = LatLng(
          (routeInfo.startLat + routeInfo.endLat) / 2,
          (routeInfo.startLng + routeInfo.endLng) / 2,
        );
        addressName = routeInfo.addressName;
        placeName = routeInfo.placeName;
        verticalForLevel = (routeInfo.startLat - routeInfo.endLat).abs();
        horizontalForLevel = (routeInfo.startLng - routeInfo.endLng).abs();
      });

      debugPrint('startLng: ${routeInfo.startLng}');
      debugPrint('startLat: ${routeInfo.startLat}');
      debugPrint('endLng: ${routeInfo.endLng}');
      debugPrint('endLat: ${routeInfo.endLat}');
      debugPrint('placeName: ${routeInfo.placeName}');
      debugPrint('addressName: ${routeInfo.addressName}');

      return true; // RouteInfo 객체를 반환
    } else {
      debugPrint('요청 실패: HTTP 상태 코드 ${response.statusCode}');
      return false; // 실패 시 false 반환
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPath = _loadExistingPath();
  }

  @override
  Widget build(BuildContext context) {
    const startSrc =
        'https://bada-bucket.s3.ap-northeast-2.amazonaws.com/flutter/start.png';
    const endSrc =
        'https://bada-bucket.s3.ap-northeast-2.amazonaws.com/flutter/end.png';

    return FutureBuilder(
      future: _loadPath,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Future가 완료되지 않은 경우
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xff4d7cfe),
              foregroundColor: Colors.white,
              title: Row(
                // Flex 대신 Row 사용
                mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                children: [
                  Expanded(
                    // Flexible 대신 Expanded 사용
                    child: Center(
                      child: Text(
                        addressName!,
                        style: const TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis, // 텍스트 오버플로우 시 생략
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    // Flexible 대신 Expanded 사용
                    child: Center(
                      child: Text(
                        placeName!,
                        style: const TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis, // 텍스트 오버플로우 시 생략
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 30),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios), // 원하는 아이콘으로 변경
                onPressed: () {
                  Navigator.pop(context); // 현재 화면을 닫고 이전 화면으로 돌아가기
                },
                padding: const EdgeInsets.only(right: 0),
              ),
            ),
            body: Stack(
              children: [
                KakaoMap(
                  onMapCreated: ((controller) {
                    mapController = controller;
                    if (verticalForLevel! > 0.127 ||
                        horizontalForLevel! > 0.096) {
                      mapController.setLevel(9);
                    } else if (verticalForLevel! > 0.0676 ||
                        horizontalForLevel! > 0.0518) {
                      mapController.setLevel(8);
                    } else if (verticalForLevel! > 0.0395 ||
                        horizontalForLevel! > 0.0246) {
                      mapController.setLevel(7);
                    } else if (verticalForLevel! > 0.0177 ||
                        horizontalForLevel! > 0.014) {
                      mapController.setLevel(6);
                    } else if (verticalForLevel! > 0.009 ||
                        horizontalForLevel! > 0.00551) {
                      mapController.setLevel(5);
                    } else if (verticalForLevel! > 0.0049 ||
                        horizontalForLevel! > 0.0023) {
                      mapController.setLevel(4);
                    } else {
                      mapController.setLevel(3);
                    }
                    // 경로를 지도에 그리기 위한 Polyline 객체 생성
                    polylines.add(
                      Polyline(
                        polylineId: 'path_${polylines.length}',
                        points: pathPoints,
                        strokeColor: Colors.blue,
                        strokeOpacity: 1,
                        strokeWidth: 5,
                        strokeStyle: StrokeStyle.solid,
                      ),
                    );
                    setState(() {});
                    markers.add(
                      Marker(
                        markerId: 'departure',
                        latLng: departure!,
                        markerImageSrc: startSrc,
                        width: 50,
                      ),
                    );
                    markers.add(
                      Marker(
                        markerId: 'destination',
                        latLng: destination!,
                        markerImageSrc: endSrc,
                        width: 50,
                      ),
                    );
                  }),
                  markers: markers.toList(),
                  polylines: polylines.toList(),
                  center: middle,
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      await _requestCurrentLocation();
                      // markerId가 'currentLocation'인 마커를 markers 집합에서 제거
                      markers.removeWhere(
                        (marker) => marker.markerId == 'currentLocation',
                      );
                      markers.add(
                        Marker(
                          markerId: 'currentLocation',
                          latLng: currentLocation!,
                          markerImageSrc: childProfileUrl!,
                          width: 50,
                        ),
                      );
                      setState(() {});
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(childProfileUrl!),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
