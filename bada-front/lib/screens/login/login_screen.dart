import 'package:bada/login/login_platform.dart';
import 'package:bada/provider/profile_provider.dart';
import 'package:bada/screens/login/screen/initial_screen.dart';
import 'package:bada/screens/main/main_screen.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: UIhelper.scaleHeight(context) * 100),
              const Text(
                '로그인',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              SizedBox(
                height: UIhelper.scaleHeight(context) * 100,
              ),
              Image.asset(
                'assets/img/bag.png',
                width: UIhelper.scaleWidth(context) * 200,
                height: UIhelper.scaleHeight(context) * 200,
              ),
              SizedBox(
                height: UIhelper.scaleHeight(context) * 120,
              ),
              GestureDetector(
                onTap: () async {
                  LoginPlatform loginPlatform = LoginPlatform.kakao;
                  await profileProvider
                      .initProfile(loginPlatform); // 소셜 로그인 진행 및 정보 가져오기
                  bool hasProfile = await profileProvider
                      .profileDbCheck(); // 데이터베이스에 아이디가 있는지 확인하고 있으면 response로 받은 accessToken Storage에 저장
                  // 아이디가 데이터베이스에 있는 경우
                  if (hasProfile) {
                    await profileProvider
                        .saveProfileToStorage(); // 프로필 정보를 DB에서 가져온 뒤 Storage에 저장
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else {
                    // 아이디가 데이터베이스에 없는 경우
                    // 소셜 로그인만 진행하고 DB에 없을 때 = 앱 처음 사용할 때
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InitialScreen(),
                      ),
                    );
                  }
                },
                child: Image.asset(
                  'assets/img/kakao_login.png',
                  width: UIhelper.scaleWidth(context) * 200,
                  height: UIhelper.scaleHeight(context) * 50,
                ),
              ),
              SizedBox(
                height: UIhelper.scaleHeight(context) * 5,
              ),
              GestureDetector(
                onTap: () async {
                  LoginPlatform loginPlatform = LoginPlatform.naver;

                  await profileProvider
                      .initProfile(loginPlatform); // 소셜 로그인 진행 및 정보 가져오기
                  bool hasProfile = await profileProvider
                      .profileDbCheck(); // 데이터베이스에 아이디가 있는지 확인하고 있으면 response로 받은 accessToken Storage에 저장
                  // 아이디가 데이터베이스에 있는 경우
                  if (hasProfile) {
                    await profileProvider
                        .saveProfileToStorage(); // 프로필 정보를 DB에서 가져온 뒤 Storage에 저장
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else {
                    // 아이디가 데이터베이스에 없는 경우
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InitialScreen(),
                      ),
                    );
                  }
                },
                child: Image.asset(
                  'assets/img/naver_login.png',
                  width: UIhelper.scaleWidth(context) * 200,
                  height: UIhelper.scaleHeight(context) * 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
