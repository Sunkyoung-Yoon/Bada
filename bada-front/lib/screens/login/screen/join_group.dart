import 'dart:convert';
import 'dart:developer';
import 'package:bada/provider/profile_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:bada/functions/secure_storage.dart';
import 'package:bada/screens/main/main_screen.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class JoinFamily extends StatefulWidget {
  final String title, buttonName;

  const JoinFamily({
    super.key,
    this.title = '그룹 참가하기',
    this.buttonName = '참가하기',
  });

  @override
  State<JoinFamily> createState() => _JoinFamilyState();
}

class _JoinFamilyState extends State<JoinFamily> {
  final TextEditingController _familyCodeController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TokenStorage _tokenStorage = TokenStorage();
  Future<void>? _inputPhoneNumberFuture;
  bool isMessageVisible = false; // 메시지 보이기/숨기기 상태
  bool _isRequestFailed = false; // 요청 실패 상태 관리

  @override
  void dispose() {
    _familyCodeController.dispose();
    super.dispose();
  }

  // fcm 토큰 가져오기
  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  Future<void> _inputPhoneNumber() async {
    var phone = await SmsAutoFill().hint;
    // await changePhoneNumber();
    if (phone != null && phone.startsWith('+82')) {
      phone = '0${phone.substring(3)}';
    }
    setState(() {
      _phoneController.text = phone ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _inputPhoneNumberFuture = _inputPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<ProfileProvider>(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _inputPhoneNumberFuture,
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: UIhelper.scaleHeight(context) * 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '인증 코드 입력',
                        style: TextStyle(
                          fontSize: 15,
                          color: _isRequestFailed
                              ? Colors.red
                              : const Color(0xff696DFF),
                        ),
                      ),
                      SizedBox(
                        width: UIhelper.scaleWidth(context) * 5,
                      ), // 인증 코드와 메시지 사이의 간격
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              setState(() {
                                isMessageVisible =
                                    !isMessageVisible; // 메시지 상태 토글
                              });
                            },
                            child: Icon(
                              Icons.help_outline_rounded,
                              color: const Color(0xff696DFF),
                              size: deviceWidth * 0.05, // 아이콘의 크기 조정
                            ),
                          ),
                          Visibility(
                            visible:
                                isMessageVisible, // 메시지 상태에 따라 Visibility 조정
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 8,
                              ), // 아이콘과 메시지 사이의 간격
                              child: const Text(
                                '부모 앱 설정 -> 인증코드 발급',
                                style: TextStyle(
                                  color: Color(0xff696DFF),
                                  fontSize: 12, // 메시지의 폰트 크기 조정
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: UIhelper.scaleHeight(context) * 5),
                  TextField(
                    controller: _familyCodeController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff696DFF).withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: _isRequestFailed
                              ? Colors.red
                              : const Color(0xff696DFF)
                                  .withOpacity(0.4), // 요청 실패 시 빨간색
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderSide: BorderSide(
                          color: _isRequestFailed
                              ? Colors.red
                              : const Color(0xff696DFF)
                                  .withOpacity(0.4), // 요청 실패 시 빨간색
                          width: 1.0,
                        ),
                      ),
                      hintText: '인증 코드를 입력해주세요',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: deviceHeight * 0.02,
                        horizontal: deviceWidth * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(height: UIhelper.scaleHeight(context) * 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '휴대전화 번호',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff696DFF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: UIhelper.scaleHeight(context) * 5),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff696DFF).withOpacity(0.2),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      hintText: '번호를 입력해주세요',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: deviceHeight * 0.02,
                        horizontal: deviceWidth * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(height: UIhelper.scaleHeight(context) * 300),
                  Button714_150(
                    label: const Text('참가하기'),
                    onPressed: () async {
                      final fcmToken = await getFcmToken(); // FCM 토큰 얻기
                      if (fcmToken != null) {
                        await joinSignUp(
                          name: userData.nickname!,
                          phone: _phoneController.text,
                          email: userData.email!,
                          social: userData.social!,
                          code: _familyCodeController.text,
                          fcmToken: fcmToken,
                        );
                      } else {
                        debugPrint('FCM 토큰 받아오기 실패, Failed to get FCM token');
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> joinSignUp({
    required String name,
    required String phone,
    required String email,
    required String social,
    String? profileUrl,
    required String code,
    required String fcmToken,
  }) async {
    final Uri url = Uri.parse('https://j10b207.p.ssafy.io/api/auth/join');
    final userData = Provider.of<ProfileProvider>(context, listen: false);

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'phone': phone,
        'email': email,
        'social': social,
        'profileUrl': profileUrl,
        'code': code,
        'fcmToken': fcmToken,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final accessToken = responseBody['accessToken'];
      final refreshToken = responseBody['refreshToken'];
      final familyName = responseBody['familyName'];
      await userData.setPhoneAndFamilyName(
        _phoneController.text,
        familyName,
      );
      await userData.saveProfileToStorageWithoutRequest();

      // Use the TokenStorage class to save the tokens
      final tokenStorage = TokenStorage();
      await tokenStorage.saveToken(accessToken, refreshToken);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else if (response.statusCode == 404) {
      // 인증 코드 불일치
      setState(() {
        _isRequestFailed = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증코드를 확인해주세요.')),
      );
    } else {
      // Handle failure
      debugPrint('Failed to sign up: ${response.body}');
    }
  }
}
