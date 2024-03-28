import 'package:bada/models/screen_size.dart';
import 'package:bada/screens/login/login_screen.dart';
import 'package:bada/screens/main/main_screen.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    await Future.delayed(const Duration(seconds: 2));

    if (accessToken == null) {
      debugPrint('토큰 못잡음');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      final isValid = await _verifyToken(accessToken);
      if (isValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        debugPrint('토큰 not valid');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    }
  }

  Future<bool> _verifyToken(String token) async {
    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/members'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint(response.statusCode.toString());
      await _storage.delete(key: 'accessToken');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF9E88FF).withOpacity(0.18),
              const Color(0xFF83A3FF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: UIhelper.scaleHeight(context) * 150,
              ),
              const Text(
                '바래다줄게',
                style: TextStyle(
                  color: Color(0xff7B79FF),
                  fontSize: 34,
                ),
              ),
              SizedBox(
                height: UIhelper.scaleHeight(context) * 130,
              ),
              Image.asset(
                'assets/img/whistle.png',
                width: UIhelper.scaleWidth(context) * 200,
              ),
              SizedBox(
                height: UIhelper.scaleHeight(context) * 130,
              ),
              const Text(
                '우리 아이',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: 'Spoqa',
                ),
              ),
              const Text(
                '안심 귀가',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
