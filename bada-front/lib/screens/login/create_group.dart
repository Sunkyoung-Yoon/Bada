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

  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: UIhelper.scaleHeight(context) * 40),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '가족 그룹 별명',
                    style: TextStyle(
                      fontSize: 19,
                      color: Color(0xff696DFF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: UIhelper.scaleHeight(context) * 20),
              TextField(
                controller: _familyNameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xff696DFF).withOpacity(0.2),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  labelText: '작성해주세요',
                ),
              ),
              SizedBox(height: UIhelper.scaleHeight(context) * 400),
              Button714_150(
                label: Text(widget.buttonName),
                onPressed: () async {
                  final fcmToken = await getFcmToken(); // FCM 토큰 얻기
                  if (fcmToken != null) {
                    debugPrint('FCM 토큰: $fcmToken');
                    signUp(
                      name: userData.nickname!,
                      phone: userData.phone!,
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
      ),
    );
  }

  Future<void> signUp({
    required String name,
    required String phone,
    required String email,
    required String social,
    required String profileUrl,
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
