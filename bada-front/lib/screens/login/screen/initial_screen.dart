import 'package:bada/screens/login/screen/create_group.dart';
import 'package:bada/screens/login/screen/join_group.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: UIhelper.scaleHeight(context) * 150),
            const Text(
              '바래다줄게',
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: UIhelper.scaleHeight(context) * 350),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: UIhelper.scaleWidth(context) * 50),
                const Text(
                  '새로운 그룹을 만들어서 시작해요!',
                  style: TextStyle(
                    color: Color(0xff969DFF),
                  ),
                ),
              ],
            ),
            SizedBox(height: UIhelper.scaleHeight(context) * 20),
            Button714_150(
              label: const Text(
                '가족 그룹 만들기',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateFamily(),
                  ),
                );
              },
            ),
            SizedBox(height: UIhelper.scaleHeight(context) * 15),
            Button714_150(
              label: const Text(
                '그룹 참가하기',
                style: TextStyle(
                  color: Colors.white,
                ), // Match your text style
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JoinFamily(),
                  ),
                );
              },
            ),
            SizedBox(
              height: UIhelper.scaleHeight(context) * 20,
            ),
          ],
        ),
      ),
    );
  }
}
