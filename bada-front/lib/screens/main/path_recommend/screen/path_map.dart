import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class PathMap extends StatefulWidget {
  // TODO : 경로 List 받아오기 및 경로 폴리라인 그리기
  const PathMap({super.key});

  @override
  State<PathMap> createState() => _PathMapState();
}

class _PathMapState extends State<PathMap> {
  late KakaoMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('경로 추천'),
      ),
      body: Stack(
        // TODO : 아이의 정보를 받아오기 POST요청 및 그 숫자만큼 CircleAvatar 생성
        // TODO : circleAvatar를 터치하면 아이의 위치를 표시할 수 있도록 함
        children: [
          KakaoMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
          ),
          Positioned(
            right: 20, // 오른쪽으로부터 20px 떨어진 위치
            top: 20, // 상단으로부터 20px 떨어진 위치
            child: GestureDetector(
              onTap: () {
                debugPrint("CircleAvatar 터치!");
              },
              child: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
