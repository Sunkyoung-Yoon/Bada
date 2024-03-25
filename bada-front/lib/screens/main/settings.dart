import 'package:bada/provider/profile_provider.dart';
import 'package:bada/screens/login/login_screen.dart';
import 'package:bada/screens/main/setting/alarm_setting.dart';
import 'package:bada/screens/main/setting/setting_list.dart';
import 'package:bada/screens/main/setting/terms_of_policy.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _storage = const FlutterSecureStorage();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width:
                    double.infinity, // Make the Container fit the screen width
                child: FutureBuilder<Map<String, String?>>(
                  future: _fetchUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      // Data loaded
                      final data = snapshot.data!;
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
              InkResponse(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlarmSetting(),
                    ),
                  );
                },
                containedInkWell: true,
                child: const Text(
                  '알림 설정',
                  style: TextStyle(fontSize: 18),
                ),
              ),
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
                            onPressed: () {
                              Navigator.of(context).pop();
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
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: UIhelper.scaleHeight(context) * 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetails(Map<String, String?> userData) {
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
                  Text(userData['nickname'] ?? '이름 없음'),
                  Text(userData['phone'] ?? '전화번호 없음'),
                  Text(userData['email'] ?? '이메일 없음'),
                  Text('가입일: ${userData['createdAt'] ?? '미등록'}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
