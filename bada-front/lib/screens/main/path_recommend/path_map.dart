import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PathMap extends StatefulWidget {
  const PathMap({super.key});

  @override
  State<PathMap> createState() => _PathMapState();
}

// TODO : 기존 경로를 불러오는 기능 구현
class _PathMapState extends State<PathMap> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void pathRequest() async {
    var accessToken = await secureStorage.read(key: 'accessToken');
    var url = Uri.parse('https://j10b207.p.ssafy.io/api');
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
