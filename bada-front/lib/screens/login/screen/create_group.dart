import 'dart:convert';
import 'package:bada/functions/secure_storage.dart';
import 'package:bada/screens/main/main_screen.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:http/http.dart' as http;
import 'package:bada/provider/profile_provider.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sms_autofill/sms_autofill.dart';

class CreateFamily extends StatefulWidget {
  final String title, buttonName;

  const CreateFamily({
    super.key,
    this.title = '가족 그룹 만들기',
    this.buttonName = '만들기',
  });

  @override
  State<CreateFamily> createState() => _CreateFamilyState();
}

class _CreateFamilyState extends State<CreateFamily> {
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Future<void>? _inputPhoneNumberFuture;

  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    super.dispose();
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
                  SizedBox(height: deviceHeight * 0.02),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '가족 그룹 별명',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff696DFF),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: deviceHeight * 0.01),
                  TextField(
                    controller: _familyNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff696DFF).withOpacity(0.2),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      hintText: '별명을 작성해주세요',
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
                    label: Text(widget.buttonName),
                    onPressed: () async {
                      final fcmToken = await getFcmToken(); // FCM 토큰 얻기
                      if (fcmToken != null) {
                        debugPrint('FCM 토큰: $fcmToken');
                        await userData.setPhoneAndFamilyName(
                          _phoneController.text,
                          _familyNameController.text,
                        );
                        await userData.saveProfileToStorageWithoutRequest();
                        await signUp(
                          name: userData.nickname!,
                          phone: _phoneController.text,
                          email: userData.email!,
                          social: userData.social!,
                          familyName: _familyNameController.text,
                          profileUrl: userData.profileImage!,
                          fcmToken: fcmToken, // FCM 토큰을 signUp 함수에 전달
                        );
                      } else {
                        // FCM 토큰을 얻지 못한 경우의 처리
                        debugPrint('FCM 토큰을 얻지 못했습니다.');
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

  Future<void> signUp({
    required String name,
    required String phone,
    required String email,
    required String social,
    String? profileUrl,
    required String familyName,
    required String fcmToken,
  }) async {
    final Uri url = Uri.parse('https://j10b207.p.ssafy.io/api/auth/signup');

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
        'familyName': familyName,
        'fcmToken': fcmToken,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final accessToken = responseBody['accessToken'];
      final refreshToken = responseBody['refreshToken'];

      // Use the TokenStorage class to save the tokens
      final tokenStorage = TokenStorage();
      await tokenStorage.saveToken(accessToken, refreshToken);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      // Handle failure
      debugPrint('Failed to sign up: ${response.body}');
    }
  }
}
