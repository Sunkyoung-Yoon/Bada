import 'package:bada/social_login/login_platform.dart';
import 'package:bada/provider/profile_provider.dart';
import 'package:bada/screens/login/screen/initial_screen.dart';
import 'package:bada/screens/main/main_screen.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  await profileProvider.initProfile(loginPlatform);
                  bool hasProfile = await profileProvider.profileDbCheck();

                  if (hasProfile) {
                    await profileProvider.saveProfileToStorage();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else {
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

                  await profileProvider.initProfile(loginPlatform);
                  bool hasProfile = await profileProvider.profileDbCheck();
                  if (hasProfile) {
                    await profileProvider.saveProfileToStorage();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else {
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
