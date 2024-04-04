import 'package:bada/api_request/member_api.dart';
import 'package:bada/provider/profile_provider.dart';
import 'package:bada/screens/login/screen/initial_screen.dart';
import 'package:bada/screens/login/login_screen.dart';
import 'package:bada/screens/main/setting/screen/authentication_screen.dart';
import 'package:bada/screens/main/setting/screen/terms_of_policy.dart';
import 'package:bada/widgets/appbar.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  final _storage = const FlutterSecureStorage();
  Future<void>? _load;
  String? accessToken;

  Future<Map<String, String?>> _fetchUserData() async {
    String? nickname = await _storage.read(key: 'nickname');
    String? email = await _storage.read(key: 'email');
    String? createdAt = await _storage.read(key: 'createdAt');
    String? phone = await _storage.read(key: 'phone');
    return {
      'nickname': nickname,
      'email': email,
      'createdAt': createdAt,
      'phone': phone,
    };
  }

  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lottieController.repeat(period: const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    if (_lottieController.isAnimating) {
      _lottieController.stop();
    }
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _load,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: const CustomAppBar(
            title: '설정',
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double
                        .infinity, // Make the Container fit the screen width
                    child: FutureBuilder<Map<String, String?>>(
                      future: _fetchUserData(),
                      builder: (context, snapshot2) {
                        if (snapshot2.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          // Data loaded
                          final data = snapshot2.data!;
                          return _buildUserDetails(data);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: UIhelper.scaleHeight(context) * 100,
                  ),
                  InkResponse(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VerificationCode(),
                        ),
                      );
                    },
                    containedInkWell: true,
                    child: const Text(
                      '인증코드 발급',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: UIhelper.scaleHeight(context) * 40),
                  SizedBox(height: UIhelper.scaleHeight(context) * 40),
                  InkResponse(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TermsOfPolicy(),
                        ),
                      );
                    },
                    containedInkWell: true,
                    child: const Text(
                      '이용약관',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: UIhelper.scaleHeight(context) * 40),
                  InkResponse(
                    onTap: () async {
                      await Provider.of<ProfileProvider>(context, listen: false)
                          .logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    containedInkWell: true,
                    child: const Text(
                      '로그아웃',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: UIhelper.scaleHeight(context) * 40),
                  InkResponse(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text('회원탈퇴'),
                            content: const Text(
                              '회원탈퇴를 진행하시겠습니까?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  MembersApi membersApi = MembersApi();

                                  try {
                                    await Provider.of<ProfileProvider>(
                                      context,
                                      listen: false,
                                    ).logout();

                                    await membersApi.deleteMember();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const InitialScreen(),
                                      ),
                                    );
                                  } catch (error) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('에러'),
                                          content: const Text(
                                            '회원탈퇴에 실패하였습니다. 문제가 계속 발생되면 000@ssafy.com으로 문의 주시기 바랍니다',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('확인'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: const Text('탈퇴하기'),
                              ),
                              // Delete button
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('취소'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    containedInkWell: true,
                    child: const Text(
                      '회원탈퇴',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  ),
                  SizedBox(height: UIhelper.scaleHeight(context) * 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserDetails(Map<String, String?> userData) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    String formatPhoneNumber(String phoneNumber) {
      if (phoneNumber.length == 11) {
        return '${phoneNumber.substring(0, 3)}-${phoneNumber.substring(3, 7)}-${phoneNumber.substring(7, 11)}';
      }
      return phoneNumber;
    }

    String formatCreatedAt(String createdAt) {
      createdAt = createdAt.substring(0, 10);
      return '$createdAt 가입';
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity, // Make the Container fit the screen width
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person),
                      SizedBox(
                        width: deviceWidth * 0.02,
                      ),
                      Text("${userData['nickname']}"),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.phone),
                      SizedBox(
                        width: deviceWidth * 0.02,
                      ),
                      Text(formatPhoneNumber(userData['phone']!)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.email),
                      SizedBox(
                        width: deviceWidth * 0.02,
                      ),
                      Text("${userData['email']}"),
                    ],
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  Text(formatCreatedAt(userData['createdAt']!)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
