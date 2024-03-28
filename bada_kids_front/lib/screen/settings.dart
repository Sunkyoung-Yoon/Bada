import 'package:bada_kids_front/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void logoutRequest() async {
    var accessToken = await secureStorage.read(key: 'accessToken');
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/auth/logout');
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

  void accountDeletionRequest() async {
    var accessToken = await secureStorage.read(key: 'accessToken');
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/members');
    var response = await http.delete(
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
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: deviceHeight * 0.65,
            ),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(deviceWidth * 0.1, 0, 0, 0),
              title: const Text('로그아웃'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      icon: const Icon(Icons.logout),
                      title: const Text("로그아웃"),
                      content: const Text("로그아웃하시겠습니까?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("취소"),
                          onPressed: () {
                            Navigator.of(context).pop(); // 팝업 닫기
                          },
                        ),
                        TextButton(
                          child: const Text("확인"),
                          onPressed: () {
                            Navigator.of(context).pop(); // 팝업 닫기
                            // 로그아웃 요청
                            logoutRequest();
                            // 로그아웃 시 로컬 저장소에 저장된 토큰 삭제
                            secureStorage.deleteAll();

                            // Login 화면으로 이동
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(deviceWidth * 0.1, 0, 0, 0),
              title: const Text('회원탈퇴'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      icon: const Icon(Icons.warning),
                      iconColor: Colors.red,
                      title: const Text("회원탈퇴"),
                      content: const Text("정말로 회원탈퇴하시겠습니까?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("취소"),
                          onPressed: () {
                            Navigator.of(context).pop(); // 팝업 닫기
                          },
                        ),
                        TextButton(
                          child: const Text("확인"),
                          onPressed: () {
                            Navigator.of(context).pop(); // 팝업 닫기
                            // 회원탈퇴 요청
                            accountDeletionRequest();
                            // 회원탈퇴 시 로컬 저장소에 저장된 토큰 삭제
                            secureStorage.deleteAll();

                            // Login 화면으로 이동
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
