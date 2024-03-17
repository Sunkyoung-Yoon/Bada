import 'package:bada/screens/main/my_family/alarm_list.dart';
import 'package:bada/screens/main/my_family/child_setting.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:flutter/material.dart';

class FamilyMember extends StatefulWidget {
  final String name;
  const FamilyMember({
    super.key,
    required this.name,
  });

  @override
  State<FamilyMember> createState() => _FamilyMemberState();
}

class _FamilyMemberState extends State<FamilyMember> {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 35,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.name,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
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
            ),
            const SizedBox(height: 10),
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
                        builder: (context) => ChildeSetting(name: widget.name),
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
  }
}
