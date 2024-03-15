import 'package:bada/provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:bada/screens/login/login_screen.dart';
import 'package:bada/screens/main/loading_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  // String appKey = dotenv.get("APP_KEY");
  KakaoSdk.init(
    nativeAppKey: '9d4c295f031b5c1f50269e353e895e12',
  );

  // String? url = await receiveKakaoScheme();
  // // url에 커스텀 URL 스킴이 할당됩니다. 할당된 스킴의 활용 코드를 작성합니다.

  // kakaoSchemeStream.listen((url) {
  //   // url에 커스텀 URL 스킴이 할당됩니다. 할당된 스킴의 활용 코드를 작성합니다.
  // }, onError: (e) {
  //   // 에러 상황의 예외 처리 코드를 작성합니다.
  // });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        // 다른 프로바이더들...
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Initialization logic with mandatory 1-second delay
  Future<void> initializeApp() async {
    // Perform initialization tasks here

    // Force a 1-second delay
    await Future.delayed(const Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Pretendard'),
      home: FutureBuilder(
        future: initializeApp(),
        builder: (context, snapshot) {
          // Check if the future is completed
          if (snapshot.connectionState == ConnectionState.done) {
            // Return the main screen if initialization is complete
            return const LoginScreen(); // Your main screen widget
          } else {
            // Return the loading screen while waiting
            return const LoadingScreen();
          }
        },
      ),
    );
  }
}
