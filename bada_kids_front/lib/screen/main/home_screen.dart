import 'dart:convert';
import 'package:bada_kids_front/model/buttons.dart';
import 'package:bada_kids_front/model/member.dart';
import 'package:bada_kids_front/model/screen_size.dart';
import 'package:bada_kids_front/provider/map_provider.dart';
import 'package:bada_kids_front/screen/main/navigator/destination_select_screen.dart';
import 'package:bada_kids_front/screen/existing_route_screen.dart';
import 'package:bada_kids_front/screen/settings.dart';
import 'package:bada_kids_front/widget/fam_member.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  MapProvider mapProvider = MapProvider.instance;

  Future<List<Member>>? _familyList;

  String? _profileUrl;
  String? _name;

  @override
  void initState() {
    super.initState();
    _loadProfileFromBackEnd();
    loadFamilyList();
  }

  Future<void> _loadProfileFromBackEnd() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    debugPrint('accessToken: $accessToken');

    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/members'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      setState(() {
        _profileUrl = data['profileUrl'];
        _name = data['name'];
      });
    }
  }

  Future<void> loadFamilyList() async {
    String? accessToken = await _storage.read(key: 'accessToken');
    debugPrint('accessToken: $accessToken');

    // HTTP GET 요청을 보냅니다.
    final response = await http.get(
      Uri.parse('https://j10b207.p.ssafy.io/api/family'),
      // 요청 헤더에 Authorization을 포함시킵니다.
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // 응답을 처리합니다.
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final familyListJson = data['familyList'] as List;

      List<Member> familyList =
          familyListJson.map((json) => Member.fromJson(json)).toList();

      setState(() {
        _familyList = Future.value(familyList);
      });

      debugPrint('프로필 정보를 성공적으로 불러왔습니다');
    } else {
      // 오류가 발생했을 때
      debugPrint('프로필 정보를 불러오는데 실패했습니다: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = UIhelper.deviceHeight(context);
    double deviceWidth = UIhelper.deviceWidth(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(child: Lottie.asset('assets/lottie/walking-cloud.json')),
          Positioned(
            right: UIhelper.scaleWidth(context) * -130,
            bottom: UIhelper.scaleHeight(context) * 170,
            child: Lottie.asset('assets/lottie/loading-cat.json',
                width: UIhelper.scaleWidth(context) * 400),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              deviceWidth * 0.05,
              deviceHeight * 0.08,
              deviceWidth * 0.05,
              deviceHeight * 0.08,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: _profileUrl != null
                          ? NetworkImage(_profileUrl!)
                          : Image.asset('assets/img/default_profile.png').image,
                    ),
                    Expanded(
                      // Text 위젯을 Expanded로 감싸서 남은 공간을 모두 사용하도록 함
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            deviceWidth * 0.03, 0, deviceWidth * 0.03, 0),
                        child: Text(
                          '$_name님 안녕하세요!',
                          style: const TextStyle(
                            color: Color(0xff7B79FF),
                            fontSize: 20,
                          ),
                          overflow:
                              TextOverflow.ellipsis, // 텍스트가 너무 길면 말줄임표로 처리
                        ),
                      ),
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
                      icon: Icon(
                        Icons.settings,
                        color: const Color(0xff7B79FF),
                        size: deviceWidth * 0.1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: deviceHeight * 0.05),
                Button714_300(
                  label: '어디로 갈까요?',
                  buttonImage: Image.asset('assets/img/map-phone.png'),
                  onPressed: () {
                    mapProvider.isGuideMode
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ExistingRouteScreen()))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DestinationSelectScreen()));
                  },
                ),
                SizedBox(height: deviceHeight * 0.05),

                // 가족 전화 목록
                Expanded(
                  child: FutureBuilder<List<Member>>(
                    future: _familyList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Text("데이터 로드에 실패했습니다.");
                      } else if (snapshot.hasData) {
                        // Separating members into parents and children
                        List<Member> parents = snapshot.data!
                            .where((m) => m.isParent == 1)
                            .toList();
                        List<Member> children = snapshot.data!
                            .where((m) => m.isParent == 0)
                            .toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('부모'),
                            Expanded(
                              flex:
                                  1, // Adjust flex factor to control the space allocation
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: parents
                                      .map((member) => MemberItemWidget(
                                            member: member,
                                            myName: _name ?? '',
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                            const Text('아이'),
                            Expanded(
                              flex:
                                  1, // Adjust flex factor to control the space allocation
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: children
                                      .map((member) => MemberItemWidget(
                                            member: member,
                                            myName: _name ?? '',
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const Text("데이터가 없습니다.");
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
