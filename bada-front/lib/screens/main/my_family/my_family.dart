import 'dart:convert';
import 'package:bada/provider/profile_provider.dart';
import 'package:bada/widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:bada/screens/main/my_family/screen/fam_member.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyFamily extends StatefulWidget {
  const MyFamily({super.key});

  @override
  State<MyFamily> createState() => _MyFamilyState();
}

class _MyFamilyState extends State<MyFamily> with TickerProviderStateMixin {
  bool showChildren = true;
  final _storage = const FlutterSecureStorage();
  Future<List<dynamic>>? userList;

  Future<List<dynamic>> loadJson() async {
    final accessToken = await _storage.read(key: 'accessToken');
    final memberIdStr = await _storage.read(key: 'memberId');
    final int memberId =
        int.tryParse(memberIdStr ?? '') ?? -1; // String을 int로 변환
    debugPrint('액세스 토큰 : $accessToken');
    debugPrint('멤버 아이디 : $memberId');
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
      // Explicitly cast the returned value to List<dynamic>
      final List<dynamic> tmpList =
          (data['familyList'] as List).map((item) => item as dynamic).toList();
      // 조건을 만족하는 요소를 찾습니다.
      final matchingMemberIndex =
          tmpList.indexWhere((member) => member['memberId'] == memberId);

      if (matchingMemberIndex != -1) {
        // 조건을 만족하는 요소가 있으면, 해당 요소를 리스트에서 제거합니다.
        final matchingMember = tmpList.removeAt(matchingMemberIndex);

        // 제거한 요소를 리스트의 맨 앞에 추가합니다.
        tmpList.insert(0, matchingMember);
      }

      final List<dynamic> familyList = tmpList;
      return familyList;
    } else {
      // Handle the error or invalid response
      throw Exception('Failed to load family data');
    }
  }

  late final AnimationController _lottieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lottieController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _lottieController.repeat(period: const Duration(seconds: 1));
    });
    userList = loadJson(); // Fetch data when the widget is initialized
  }

  @override
  void dispose() {
    if (_lottieController.isAnimating) {
      _lottieController.stop();
    }
    _lottieController.dispose();
    super.dispose();
  }

  void _filterFamily(bool children) {
    setState(() {
      showChildren = children;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: '우리 가족'),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: UIhelper.scaleHeight(context) * 30),
              Row(
                children: [
                  Button281_77(
                    label: const Text('아이들'),
                    onPressed: () => _filterFamily(true),
                    isSelected: showChildren,
                  ),
                  SizedBox(
                    width: UIhelper.scaleWidth(context) * 20,
                  ),
                  Button281_77(
                    label: const Text('부모'),
                    onPressed: () => _filterFamily(false),
                    isSelected: !showChildren,
                  ),
                ],
              ),
              SizedBox(height: UIhelper.scaleHeight(context) * 20),
              FutureBuilder<List<dynamic>>(
                future: userList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Adjusting the filter logic according to isParent values (0 and 1)
                    // If showChildren is true, we want to show members with isParent == 0
                    List<dynamic> members = snapshot.data!
                        .where(
                          (member) =>
                              ((member['isParent'] == 0) && showChildren) ||
                              ((member['isParent'] == 1) && !showChildren),
                        )
                        .toList();
                    return Expanded(
                      child: ListView.builder(
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          return FamilyMember(
                            memberId: members[index]['memberId'],
                            name: members[index]['name'],
                            isParent: members[index]['isParent'],
                            profileUrl: members[index]['profileUrl'],
                            movingState: members[index]['movingState'],
                          );
                        },
                      ),
                    );
                  } else {
                    return const Center(child: Text('No data'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
