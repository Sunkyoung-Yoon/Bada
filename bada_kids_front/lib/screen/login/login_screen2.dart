import 'dart:convert';

import 'package:bada_kids_front/model/buttons.dart';
import 'package:bada_kids_front/screen/main/home_screen.dart';
import 'package:bada_kids_front/model/screen_size.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../firebase_options.dart';

class LoginScreen2 extends StatefulWidget {
  final String authCode;

  const LoginScreen2({super.key, required this.authCode});

  @override
  State<LoginScreen2> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen2> {
  final TextEditingController _nameController = TextEditingController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  String? _phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestToken();
    _requestPhone();
  }

  void _requestToken() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _token = await FirebaseMessaging.instance.getToken();
    debugPrint("FCM Token: $_token");
  }

  void _requestPhone() async {
    _phone = await SmsAutoFill().hint;
    if (_phone != null && _phone!.startsWith('+82')) {
      _phone = '0${_phone!.substring(3)}';
    } else {
      // `_phone`가 `null`이거나 '+82'로 시작하지 않는 경우의 처리를 추가하세요.
      debugPrint('전화번호를 가져올 수 없거나, 올바른 형식이 아닙니다.');
    }
  }

  void login() async {
    var url = Uri.parse('https://j10b207.p.ssafy.io/api/auth/joinChild');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // JSON 형식의 데이터를 보낸다고 명시
      },
      body: jsonEncode({
        "name": _nameController.text,
        "phone": _phone,
        "profileUrl": null,
        "code": widget.authCode, // StatefulWidget에서 전달받은 authCode 사용
        "fcmToken": _token, // 실제 FCM 토큰 값으로 교체해야 합니다.
      }),
    );

    debugPrint(
        'name: ${_nameController.text},\n phone: $_phone,\n profileUrl: null,\n code: ${widget.authCode},\n fcmToken: $_token');

    if (response.statusCode == 200) {
      // JSON 형식의 응답 본문을 디코드합니다.
      var responseBody = jsonDecode(response.body);

      // familyCode와 accessToken을 저장합니다.
      await _storage.write(
          key: 'familyCode', value: responseBody['familyCode']);
      await _storage.write(
          key: 'accessToken', value: responseBody['accessToken']);

      await _storage.read(key: 'familyCode').then((value) {
        debugPrint('familyCode: $value');
      });
      await _storage.read(key: 'accessToken').then((value) {
        debugPrint('accessToken: $value');
      });

      // 요청이 성공적으로 처리된 경우
      debugPrint("성공: ${response.body}");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      // 요청 처리 실패
      debugPrint("실패: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = UIhelper.deviceHeight(context);
    double deviceWidth = UIhelper.deviceWidth(context);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: deviceHeight * 0.03),
          child: const Text('이름 입력'),
        ),
        centerTitle: true,
        leading: Padding(
          // 여기에 Padding 추가
          padding: EdgeInsets.only(top: deviceHeight * 0.03), // 상단 패딩 적용
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(), // 뒤로가기 기능 구현
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(deviceWidth * 0.07, deviceHeight * 0.05,
            deviceWidth * 0.07, deviceHeight * 0.05),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xff696DFF).withOpacity(0.2),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(13),
                  ),
                  borderSide: BorderSide.none,
                ),
                hintText: '이름을 입력해주세요',
                hintStyle: TextStyle(
                  color: const Color(0xff696DFF).withOpacity(0.5),
                ),
                contentPadding: EdgeInsets.fromLTRB(
                    deviceWidth * 0.04,
                    deviceHeight * 0.02,
                    deviceWidth * 0.04,
                    deviceHeight * 0.02),
              ),
            ),
            SizedBox(height: deviceHeight * 0.6),
            // ElevatedButton(
            //   onPressed: () {
            //     login();
            //   },
            //   child: const Text('다음으로'),
            // ),
            Button714_150(
              label: const Text(
                '다음으로',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                login();
              },
            ),
          ],
        ),
      ),
    );
  }
}
