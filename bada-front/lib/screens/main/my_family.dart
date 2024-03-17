import 'dart:convert';

import 'package:bada/screens/main/my_family/fam_member.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyFamily extends StatefulWidget {
  // Future<List<MemberModel>> members = MemberApi().getFamily();

  const MyFamily({super.key});

  @override
  State<MyFamily> createState() => _MyFamilyState();
}

class _MyFamilyState extends State<MyFamily> {
  bool showChildren = true;
  Future userList = loadJson();

  static Future loadJson() async {
    final String response =
        await rootBundle.loadString('assets/dummydata/fam_data.json');
    final data = await json.decode(response);
    return data;
  }

  @override
  void initState() {
    super.initState();
    userList = loadJson();
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
              const SizedBox(height: 30),
              Row(
                children: [
                  Button281_77(
                    label: const Text('아이들'),
                    onPressed: () => _filterFamily(true),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Button281_77(
                    label: const Text('부모'),
                    onPressed: () => _filterFamily(false),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FutureBuilder(
                future: userList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error'));
                  } else if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    List<dynamic> members = snapshot.data!
                        .where((member) => member['isParent'] != showChildren)
                        .toList();
                    return Expanded(
                      child: ListView.builder(
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          return FamilyMember(name: members[index]['name']);
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
