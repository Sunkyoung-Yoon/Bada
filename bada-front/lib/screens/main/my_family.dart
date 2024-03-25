import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bada/screens/main/my_family/fam_member.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyFamily extends StatefulWidget {
  const MyFamily({super.key});

  @override
  State<MyFamily> createState() => _MyFamilyState();
}

class _MyFamilyState extends State<MyFamily> {
  bool showChildren = true;
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
      // Explicitly cast the returned value to List<dynamic>
      final List<dynamic> familyList =
          (data['familyList'] as List).map((item) => item as dynamic).toList();
      return familyList;
    } else {
      // Handle the error or invalid response
      throw Exception('Failed to load family data');
    }
  }

  @override
  void initState() {
    super.initState();
    userList = loadJson(); // Fetch data when the widget is initialized
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
      appBar: AppBar(
        title: const Text('우리 가족'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
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
                  ),
                  SizedBox(
                    width: UIhelper.scaleWidth(context) * 20,
                  ),
                  Button281_77(
                    label: const Text('부모'),
                    onPressed: () => _filterFamily(false),
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
                            name: members[index]['name'],
                            isParent: members[index]['isParent'],
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
