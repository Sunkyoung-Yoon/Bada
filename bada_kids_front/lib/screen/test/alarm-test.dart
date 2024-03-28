import 'dart:convert';

import 'package:bada_kids_front/provider/map_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_map_plugin/kakao_map_plugin.dart';

class AlarmTest extends StatefulWidget {
  const AlarmTest({super.key});

  @override
  State<AlarmTest> createState() => _AlarmTestState();
}

class _AlarmTestState extends State<AlarmTest> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _familyCode, _name;
  int? _memberId;
  MapProvider mapProvider = MapProvider.instance;

  late LatLng currentLocation;
  late Future<String?> fcmToken;

  Future<void> _loadProfileFromBackEnd() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    debugPrint('accessToken: $accessToken');

    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/members'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      setState(() {
        _familyCode = data['familyCode'];
        _name = data['name'];
        _memberId = data['memberId'];
        fcmToken = FirebaseMessaging.instance.getToken();
      });
    }
  }

  Future<void> getCurrentLocation() async {}

  @override
  void initState() {
    super.initState();
    _loadProfileFromBackEnd();
    currentLocation = mapProvider.currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테스트'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                sendAlarm(
                  familyCode: _familyCode!,
                  memberId: _memberId!,
                  latitude: currentLocation.latitude,
                  longitude: currentLocation.longitude,
                );
              },
              child: const Text('test'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendAlarm({
    required String familyCode,
    required int memberId,
    required double latitude,
    longitude,
  }) async {
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/kafka/alarm');

    // var accessToken = _storage.read(key: 'accessToken');
    var currLocation = mapProvider.currentLocation;

    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(<String, dynamic>{
        'type': 'ALARM-TYPE',
        'familyCode': familyCode,
        'memberId': memberId,
        'content': 'test 범위 이탈 감지 알림이 발생했습니다',
        'latitude': currLocation.latitude,
        'longitude': currLocation.longitude,
      }),
    );

    var fcmToken = await FirebaseMessaging.instance.getToken();

    if (response.statusCode == 200) {
      print(currLocation);
      print('Success: ${response.body}');
      print('$familyCode $memberId');
    } else {
      throw Exception('Failed to load data');
    }
  }
}
