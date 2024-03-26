import 'package:bada/screens/main/my_family.dart';
import 'package:bada/screens/main/my_place.dart';
import 'package:bada/screens/main/settings.dart';
import 'package:bada/screens/main/testing/testing.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = const FlutterSecureStorage();

  String profileUrl = "";
  @override
  void initState() {
    super.initState();
    _loadProfileFromStorage();
  }

  void _loadProfileFromStorage() async {
    await _storage.read(key: 'profileImage').then((value) {
      setState(() {
        profileUrl = value ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Transform.translate(
            offset: const Offset(60, 570),
            child: Image.asset('assets/img/map-bg.png'),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('테스트'),
                ),
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: profileUrl == ''
                          ? Image.asset('assets/img/default_profile.png').image
                          : NetworkImage(
                              profileUrl,
                            ),
                    ),
                  ],
                ),
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button330_220(
                      label: '우리 가족',
                      backgroundColor: const Color(0xff777CFF),
                      foregroundColor: Colors.white,
                      buttonImage: Image.asset(
                        'assets/img/family-button.png',
                      ),
                      imageWidth: UIhelper.scaleWidth(context) * 120,
                      padBottom: 0,
                      padRight: 5,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyFamily(),
                          ),
                        );
                      },
                    ),
                    Button330_220(
                      label: '내 장소',
                      buttonImage: Lottie.asset(
                        'assets/lottie/location-pin.json',
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyPlace(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 15,
                ),
                Button714_300(
                  label: '경로 추천 받기',
                  buttonImage: Image.asset('assets/img/map-phone.png'),
                  onPressed: () {},
                ),
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button330_220(
                      label: '설정',
                      buttonImage: Lottie.asset('assets/lottie/settings.json'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Settings(),
                          ),
                        );
                      },
                    ),
                    Button330_220(
                      label: '테스트 전용',
                      buttonImage: Lottie.asset('assets/lottie/settings.json'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Test(),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: UIhelper.scaleWidth(context) * 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
