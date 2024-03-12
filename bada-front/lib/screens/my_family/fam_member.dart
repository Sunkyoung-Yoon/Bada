import 'package:bada/widgets/buttons.dart';
import 'package:flutter/material.dart';

class FamilyMember extends StatelessWidget {
  final String name;
  const FamilyMember({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff696DFF), width: 0.5),
            borderRadius: BorderRadius.circular(10)),
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
                  name,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                const Button281_77(label: Text('알림 기록')),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button281_77(label: Text('정지 중')),
                Button281_77(label: Text('설정')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
