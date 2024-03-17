import 'dart:developer';

import 'package:bada/provider/profile_provider.dart';
import 'package:bada/screens/main/my_family.dart';
import 'package:bada/screens/main/my_place.dart';
import 'package:bada/screens/main/settings.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final platform = const MethodChannel("testing.flutter.android");

  Future<void> _showActivity() async {
    try {
      await platform.invokeMethod('showActivity');
    } on PlatformException catch (e) {
      log("Error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
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
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: profileProvider.isLogined
                          ? NetworkImage(profileProvider.profileImage!)
                              as ImageProvider<Object>
                          : const AssetImage('assets/img/default_profile.png'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
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
                      imageWidth: 120,
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
                const SizedBox(
                  height: 15,
                ),
                Button714_300(
                  label: '경로 추천 받기',
                  buttonImage: Image.asset('assets/img/map-phone.png'),
                  onPressed: () {
                    _showActivity();
                  },
                ),
                const SizedBox(
                  height: 15,
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
                    const SizedBox(
                      width: 10,
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
