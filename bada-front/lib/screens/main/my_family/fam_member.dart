import 'package:bada/screens/main/my_family/alarm_list.dart';
import 'package:bada/screens/main/my_family/child_setting.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FamilyMember extends StatefulWidget {
  final String name;
  final int isParent;
  const FamilyMember({
    super.key,
    required this.name,
    required this.isParent,
  });

  @override
  State<FamilyMember> createState() => _FamilyMemberState();
}

class _FamilyMemberState extends State<FamilyMember> {
  String myName = '';

  @override
  void initState() {
    super.initState();
    loadMyName();
  }

  void loadMyName() async {
    const storage = FlutterSecureStorage();
    String? name = await storage.read(key: 'name');
    if (name != null) {
      setState(() {
        myName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff696DFF), width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 35,
                ),
                SizedBox(width: UIhelper.scaleWidth(context) * 10),
                // Text(
                //   '이름 : ${widget.name}',
                //   style: const TextStyle(fontSize: 16),
                // ),
                if (widget.name == myName)
                  const Text(
                    '나!',
                    style: TextStyle(fontSize: 20),
                  )
                else
                  Text(
                    '이름 : ${widget.name}',
                    style: const TextStyle(fontSize: 16),
                  ),
                SizedBox(width: UIhelper.scaleWidth(context) * 10),
                if (widget.isParent == 0) ...[
                  Button281_77(
                    label: const Text('알림 기록'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlarmList(name: widget.name),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
            if (widget.isParent == 0) ...[
              SizedBox(height: UIhelper.scaleHeight(context) * 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Button281_77(label: Text('정지 중')),
                  Button281_77(
                    label: const Text('설정'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChildeSetting(name: widget.name),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
