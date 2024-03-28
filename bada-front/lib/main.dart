import 'package:bada/models/screen_size.dart';
import 'package:bada/provider/profile_provider.dart';
import 'package:bada/screens/main/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:bada/screens/login/login_screen.dart';
import 'package:bada/loading_screen.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: '.env');

  AuthRepository.initialize(appKey: dotenv.env['KAKAO_MAP_API'] ?? '');

  KakaoSdk.init(
    nativeAppKey: '9d4c295f031b5c1f50269e353e895e12',
  );

  requestNotificationPermission();

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('fcmtoken main.dart 56 $fcmToken');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        Provider<ScreenSizeModel>(
          create: (_) => ScreenSizeModel(
            screenWidth: 0,
            screenHeight: 0,
          ),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    String? accessToken = await _storage.read(key: 'accessToken');
    return accessToken != null;
  }
  //로그인 시, 단순 storage reading이 아니라,

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Pretendard'),
      home: const LoadingScreen(),
      // FutureBuilder<bool>(
      //   future: initializeApp(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       if (snapshot.data == true) {
      //         return const HomeScreen();
      //       } else {
      //         return const LoginScreen();
      //       }
      //     } else {
      //       return const LoadingScreen();
      //     }
      //   },
      // ),
    );
  }
}
