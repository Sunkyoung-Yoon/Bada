import 'dart:async';
import 'dart:convert';
import 'package:bada_kids_front/model/screen_size.dart';
import 'package:http/http.dart' as http;
import 'package:bada_kids_front/provider/map_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart'; // SearchResultItem 모델 import 필요

class PathFindScreen extends StatefulWidget {
  final double x, y;

  const PathFindScreen({
    super.key,
    required this.x,
    required this.y,
  });

  @override
  State<PathFindScreen> createState() => _PathFindScreenState();
}

// 나머지 필요한 import들...

class _PathFindScreenState extends State<PathFindScreen> {
  late KakaoMapController mapController;
  MapProvider mapProvider = MapProvider.instance;
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  var accessToken = '';
  List<LatLng> pathPoints = [];
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  late LatLng currentLocation;
  late LatLng destination;

  // 현재 위치 정보와 목적지 위치 정보를 POST 요청으로 보내기
  Future<void> requestPath() async {
    accessToken = (await secureStorage.read(key: 'accessToken'))!;
    currentLocation = mapProvider.currentLocation; // 현재 위치 정보
    destination = LatLng(widget.y, widget.x); // 목적지 위치 정보

    var url = Uri.parse('https://j10b207.p.ssafy.io/api/path');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    var requestBody = jsonEncode({
      "startX": currentLocation.longitude,
      "startY": currentLocation.latitude,
      "endX": destination.longitude,
      "endY": destination.latitude,
    });

    var response = await http.post(url, headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      // 시작점, 경유지, 종점을 포함하는 전체 경로 리스트를 생성합니다.

      // 시작점 추가
      pathPoints.add(LatLng(double.parse(responseData['startY']),
          double.parse(responseData['startX'])));

      // 경유지 추가
      if (responseData.containsKey('passList') &&
          responseData['passList'].isNotEmpty) {
        List<String> passList = responseData['passList'].split('_');
        for (var pass in passList) {
          var coords = pass.split(',');
          if (coords.length == 2) {
            pathPoints.add(LatLng(double.parse(coords[1].trim()),
                double.parse(coords[0].trim())));
          }
        }
      }

      // 종점 추가
      pathPoints.add(LatLng(double.parse(responseData['endY']),
          double.parse(responseData['endX'])));

      // 경로를 지도에 그리기 위한 Polyline 객체 생성
      Polyline polyline = Polyline(
        polylineId: 'path',
        points: pathPoints,
        fillColor: Colors.blue, // 경로 색상 설정
      );

      setState(() {
        // 지도에 경로 표시
        polylines.add(polyline);
      });

      debugPrint('Request successful: ${response.body}');
      mapProvider.isGuideMode = true; // 길 안내 모드 활성화
    } else {
      // 오류가 발생했을 때의 로직
      debugPrint('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> savePath() async {
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/path');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    var requestBody = jsonEncode({
      "startX": currentLocation.longitude,
      "startY": currentLocation.latitude,
      "endX": destination.longitude,
      "endY": destination.latitude,
      "passList": pathPoints,
      //TODO: 경유지 정보 추가
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = UIhelper.deviceHeight(context);
    double deviceWidth = UIhelper.deviceWidth(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('길 찾기'),
      ),
      body: Expanded(
        child: KakaoMap(
          onMapCreated: (controller) {
            mapController = controller;
            requestPath(); // 현재 위치 정보와 목적지 위치 정보를 POST 요청 보내기

            // 현재 위치 지도에 마커(아이 프로필 사진)로 표시
            markers.add(Marker(
                markerId: markers.length.toString(),
                latLng: currentLocation,
                width: (deviceWidth * 0.1).toInt(),
                height: (deviceHeight * 0.08).toInt(),
                markerImageSrc: ''
                // 아이 프로필 사진 URL,
                ));

            // 목적지 지도에 마커(myPlaceIcon)로 표시
            markers.add(Marker(
                markerId: markers.length.toString(),
                latLng: destination,
                width: (deviceWidth * 0.1).toInt(),
                height: (deviceHeight * 0.08).toInt(),
                markerImageSrc: ''
                // myPlaceIcon URL,
                ));

            // 지도 중심을 현재 위치와 목적지 중간으로 이동
            mapController.setCenter(LatLng(
                (currentLocation.latitude + destination.latitude) / 2,
                (currentLocation.longitude + destination.longitude) / 2));
          },
          markers: markers.toList(),
        ),
      ),
    );
  }
}
