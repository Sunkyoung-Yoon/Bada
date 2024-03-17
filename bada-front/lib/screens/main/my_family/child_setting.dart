import 'package:bada/widgets/buttons.dart';
import 'package:flutter/material.dart';

class ChildeSetting extends StatelessWidget {
  final String name;
  const ChildeSetting({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('이름 수정'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const CircleAvatar(
              radius: 100,
            ),
            const SizedBox(
              height: 50,
            ),
            InputChip(label: Text(name)),
            const SizedBox(
              height: 170,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button300_115(label: Text('완료')),
                SizedBox(
                  width: 20,
                ),
                Button300_115(label: Text('삭제')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
