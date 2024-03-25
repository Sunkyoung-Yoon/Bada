import 'dart:convert';
import 'package:bada/provider/profile_provider.dart';
import 'package:http/http.dart' as http;
import 'package:bada/functions/secure_storage.dart';
import 'package:bada/screens/main/main_screen.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  void dispose() {
    _familyCodeController.dispose();
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
                    '인증 코드 입력',
                    style: TextStyle(
                      fontSize: 19,
                      color: Color(0xff696DFF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: UIhelper.scaleHeight(context) * 20),
              TextField(
                controller: _familyCodeController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xff696DFF).withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    borderSide: BorderSide(
                      color: const Color(0xff696DFF).withOpacity(0.4),
                    ),
                  ),
                  labelText: '작성해주세요',
                ),
              ),
              SizedBox(height: UIhelper.scaleHeight(context) * 400),
              Button714_150(
                label: const Text('참가하기'),
                onPressed: () {
                  joinSignUp(
                    name: userData.nickname!,
                    phone: '01010',
                    email: userData.email!,
                    social: userData.social!,
                    code: _familyCodeController.text,
                  );
                },
              ),
            ],
          ),
        ),
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
  }) async {
    final Uri url = Uri.parse('https://j10b207.p.ssafy.io/api/auth/join');

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
      print('Failed to sign up: ${response.body}');
    }
  }
}
