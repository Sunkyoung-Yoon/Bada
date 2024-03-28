import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ExistingRouteScreen extends StatefulWidget {
  const ExistingRouteScreen({super.key});

  @override
  State<ExistingRouteScreen> createState() => _ExistingRouteScreenState();
}

// TODO : 기존 경로를 불러오는 기능 구현
class _ExistingRouteScreenState extends State<ExistingRouteScreen> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  Future<List>? myPlaces;

  void pathRequest() async {
    var accessToken = await secureStorage.read(key: 'accessToken');
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/myplace');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('서버로부터 응답 성공: ${response.body}');
    } else {
      print('요청 실패: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    pathRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기존 경로'),
        centerTitle: true,
      ),
      body: Container(
        child: const Column(
          children: [
            Text('기존 경로가 없습니다.'),
          ],
        ),
      ),
    );
  }
}
