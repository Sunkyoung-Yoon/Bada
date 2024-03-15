import 'package:bada/login/login_platform.dart';
import 'package:bada/provider/profile_provider.dart';
import 'package:bada/screens/login/initial_screen.dart';
import 'package:bada/screens/main/main_screen.dart';
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
              const SizedBox(height: 100),
              const Text(
                '로그인',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/img/bag.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 120,
              ),

              // 아이디가 데이터베이스에 없는 경우
              GestureDetector(
                onTap: () async {
                  LoginPlatform loginPlatform = LoginPlatform.kakao;
                  await profileProvider.initProfile(loginPlatform);
                  // await viewModel.login();
                  // setState(() {});

                  if (profileProvider.isLogined) {
                    // if(id 비교해서 데이터베이스에 없으면)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InitialScreen(),
                      ),
                    );
                    // else if (id 비교해서 데이터베이스에 있으면)
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const HomeScreen(),
                    //   ),
                    // );
                  }
                },
                child: Image.asset(
                  'assets/img/kakao_login.png',
                  width: 200,
                  height: 50,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () async {
                  LoginPlatform loginPlatform = LoginPlatform.naver;
                  await profileProvider.initProfile(loginPlatform);
                  // await viewModel.login();
                  // setState(() {});

                  if (profileProvider.isLogined) {
                    // if(id 비교해서 데이터베이스에 없으면)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InitialScreen(),
                      ),
                    );
                    // else if (id 비교해서 데이터베이스에 있으면)
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const HomeScreen(),
                    //   ),
                    // );
                  }
                },
                child: Image.asset(
                  'assets/img/naver_login.png',
                  width: 200,
                  height: 50,
                ),
              ),

              // 아이디가 데이터베이스에 있는 경우
              // if (hasId)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                child: const Text('메인 가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// 로그아웃 : viewModel.logout();
// 로그인 : viewModel.login();
// 로그인 여부 : viewModel.isLogined
// 유저 정보 : viewModel.user
// 유저 정보의 프로필 이미지 : viewModel.user?.kakaoAccount?.profile?.profileImageUrl
// 유저 정보의 닉네임 : viewModel.user?.kakaoAccount?.profile?.nickname
// 유저 정보의 이메일 : viewModel.user?.kakaoAccount?.email
