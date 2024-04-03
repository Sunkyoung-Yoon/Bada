import 'dart:convert';

import 'package:bada/api_request/member_api.dart';
import 'package:bada/screens/main/alarm/alarm_screen.dart';
import 'package:bada/screens/main/my_family/my_family.dart';
import 'package:bada/screens/main/my_place/my_place.dart';
import 'package:bada/screens/main/path_recommend/searching_path.dart';
import 'package:bada/screens/main/profile_edit.dart';
import 'package:bada/screens/main/setting/settings.dart';
import 'package:bada/screens/main/tutorial/tutorial-list.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _lottieController;

  MembersApi membersApi = MembersApi();
  final _storage = const FlutterSecureStorage();
  Future<void>? load;
  String? profileUrl;
  String? nickname;
  int? memberId;
  int unreadAlarms = 0;
  Future<bool>? _load;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observer 등록
    _lottieController = AnimationController(vsync: this);
    _load = _initializeApp();
  }

  Future<bool> _initializeApp() async {
    await _loadProfile();
    await _unreadAlarmCount();
    return true;
  }

  Future<void> _loadProfile() async {
    await membersApi.fetchProfile().then((value) {
      setState(() {
        profileUrl = value.profileUrl;
        nickname = value.name;
        memberId = value.memberId;
      });
    });
    await _storage.write(key: 'memberId', value: memberId.toString());
    await _storage.write(key: 'profileImage', value: profileUrl);
    await _storage.write(key: 'nickname', value: nickname);
  }

  Future<void> _unreadAlarmCount() async {
    String? token = await _storage.read(key: 'accessToken');
    if (token != null) {
      final res = await http.get(
        Uri.parse('https://j10b207.p.ssafy.io/api/alarmLog/list/count'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        setState(() {
          unreadAlarms = int.parse(res.body);
        });
      } else {
        debugPrint('main_s 74 ${res.statusCode}');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Observer를 해제합니다.
    _lottieController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 앱이 다시 활성화될 때 애니메이션을 재시작합니다.
    if (state == AppLifecycleState.resumed) {
      _lottieController.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
      future: _load,
      builder: (constext, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: 270,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileEdit(
                                        nickname: nickname,
                                        profileUrl: profileUrl,
                                      ),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Colors.transparent, // 배경 색상을 투명하게 설정
                                  backgroundImage:
                                      profileUrl == '' || profileUrl == null
                                          ? Image.asset(
                                              'assets/img/default_profile.png',
                                            ).image
                                          : NetworkImage(
                                              profileUrl!,
                                            ),
                                ),
                              ),
                              SizedBox(
                                width: UIhelper.scaleWidth(context) * 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '안녕하세요,',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${nickname ?? '사용자'}님!',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: deviceHeight * 0.19,
                          left: deviceWidth * 0.15,
                          child: IconButton(
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color(0xff696DFF),
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileEdit(
                                    nickname: nickname,
                                    profileUrl: profileUrl,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Settings(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings),
                    ),
                  ],
                ),
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainLarge(
                      label: '우리 가족',
                      backgroundColor: const Color(0xff777CFF),
                      foregroundColor: Colors.white,
                      buttonImage: Image.asset('assets/img/family-button.png'),
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
                    MainSmall2(
                      label: '알림',
                      buttonImage: Lottie.asset(
                        'assets/lottie/notification.json',
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AlarmScreen(),
                          ),
                        );
                      },
                      unreadAlarm: unreadAlarms.toString(),
                    ),
                  ],
                ),
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainSmall(
                      label: '내 장소',
                      buttonImage: Lottie.asset(
                        'assets/lottie/location-pin.json',
                        controller: _lottieController,
                        onLoaded: ((p0) {
                          _lottieController.duration = p0.duration;
                          _lottieController.repeat();
                        }),
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
                    MainLarge(
                      label: '경로 추천 받기',
                      buttonImage: Image.asset(
                        'assets/img/map-bg.png',
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchingPath(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: UIhelper.scaleHeight(context) * 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button714_300(
                      label: '바래다줄게 설명서',
                      buttonImage: Lottie.asset(
                        'assets/lottie/tutorial.json',
                        height: 50,
                        width: 50,
                        controller: _lottieController,
                        onLoaded: ((p0) {
                          _lottieController.duration = p0.duration;
                          _lottieController.stop();
                        }),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TutorialList(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
