import 'package:bada/screens/login/create_group.dart';
import 'package:bada/screens/login/join_group.dart';
import 'package:bada/widgets/buttons.dart';
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
            const SizedBox(height: 150),
            const Text(
              '바래다줄게',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 350),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 50),
                Text(
                  '새로운 그룹을 만들어서 시작해요!',
                  style: TextStyle(
                    color: Color(0xff969DFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Button714_150(

            //   label: '가족 그룹 만들기',
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const CreateFamily(),
            //         ));
            //   },
            // ),
            Button714_150(
              label: const Hero(
                tag:
                    'uniqueHeroTag', // Ensure this tag is unique and the same in both places
                child: Text(
                  '가족 그룹 만들기',
                  style: TextStyle(
                    color: Colors.white,
                  ), // Match your text style
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
            const SizedBox(height: 15),
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
            const SizedBox(
              height: 20,
            ),
            // const Button714_150(label: '그룹 참가하기')
          ],
        ),
      ),
    );
  }
}
