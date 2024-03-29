import 'package:bada_kids_front/model/buttons.dart';
import 'package:bada_kids_front/screen/login/login_screen2.dart';
import 'package:bada_kids_front/model/screen_size.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _authCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = UIhelper.deviceHeight(context);
    double deviceWidth = UIhelper.deviceWidth(context);
    // TODO : 테스트용 코드 나중에 지울 것
    _authCodeController.text = '5I9LN';

    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: EdgeInsets.only(top: deviceHeight * 0.03),
            child: const Text('가족 코드 입력')),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(deviceWidth * 0.07, deviceHeight * 0.05,
            deviceWidth * 0.07, deviceHeight * 0.05),
        child: Column(
          children: [
            TextField(
              controller: _authCodeController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xff696DFF).withOpacity(0.2),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(13),
                  ),
                  borderSide: BorderSide.none,
                ),
                hintText: '인증 코드를 입력해주세요',
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
            Button714_150(
              label: const Text(
                '다음으로',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen2(
                      authCode: _authCodeController.text,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
