import 'dart:convert';

import 'package:bada/screens/main/my_family/screen/fam_member.dart';
import 'package:bada/widgets/alarm.dart';
import 'package:bada/widgets/appbar.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final _storage = const FlutterSecureStorage();
  Future<List<dynamic>>? userList;

  Future<List<dynamic>> loadJson() async {
    final accessToken = await _storage.read(key: 'accessToken');
    final uri = Uri.parse('https://j10b207.p.ssafy.io/api/family');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> familyList =
          (data['familyList'] as List).map((item) => item as dynamic).toList();
      return familyList;
    } else {
      throw Exception('Failed to load family data');
    }
  }

  @override
  void initState() {
    super.initState();
    userList = loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '알림',
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  '사진',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('을 클릭하여 알림 목록을 확인하세요!'),
              ],
            ),
            SizedBox(
              height: UIhelper.deviceHeight(context) * .02,
            ),
            Row(
              children: [
                FutureBuilder<List<dynamic>>(
                  future: userList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error'));
                    } else if (snapshot.hasData) {
                      List<dynamic> members = snapshot.data!
                          .where((member) => member['isParent'] == 0)
                          .toList();
                      if (members.isNotEmpty) {
                        return Expanded(
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: members.length,
                              itemBuilder: (context, index) {
                                return FamilyMember2(
                                  name: members[index]['name'],
                                  isParent: members[index]['isParent'],
                                  profileUrl: members[index]['profileUrl'],
                                  memberId: members[index]['memberId'],
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('아직 가입된 아이가 없습니다'),
                              SizedBox(
                                height: UIhelper.deviceHeight(context) * 0.02,
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return const Center(child: Text('No data'));
                    }
                  },
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0x80EFE5FF),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '알림 종류와 설명',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: UIhelper.deviceHeight(context) * 0.02,
                  ),
                  const Text('바래다줄게 앱의 알림은 총 5가지 종류가 있습니다'),
                  SizedBox(
                    height: UIhelper.deviceHeight(context) * 0.02,
                  ),
                  Alarm(type: 'DEPART', createdAt: DateTime.now().toString()),
                  const Text('아이가 출발하기 버튼을 눌렀을 때 오는 알림입니다'),
                  SizedBox(
                    height: UIhelper.deviceHeight(context) * 0.02,
                  ),
                  Alarm(type: 'ARRIVE', createdAt: DateTime.now().toString()),
                  const Text('장소에 도착하거나, 도착하기 버튼을 눌렀을 때 오는 알립입니다'),
                  SizedBox(
                    height: UIhelper.deviceHeight(context) * 0.02,
                  ),
                  Alarm(
                    type: 'OFF COURSE',
                    createdAt: DateTime.now().toString(),
                  ),
                  const Text('정해진 경로나 지역에서 이탈했을 때 오는 알림입니다'),
                  SizedBox(
                    height: UIhelper.deviceHeight(context) * 0.02,
                  ),
                  SizedBox(
                    height: UIhelper.deviceHeight(context) * 0.02,
                  ),
                  const Text('버튼을 클릭하여 애니메이션을 확인해보세요!'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
