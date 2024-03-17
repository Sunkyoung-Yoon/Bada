import 'package:flutter/material.dart';

class VerificationCode extends StatelessWidget {
  const VerificationCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('인증코드 발급'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40),
            const Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  '발송시간 9:59',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ), // The time text
            const SizedBox(height: 20), // Space between text and code boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                for (String code in [
                  'E',
                  'R',
                  '5',
                  '2',
                  '3',
                ]) // Replace with your list of code characters
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ), // Padding inside the box
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey), // Box border color
                      borderRadius:
                          BorderRadius.circular(10.0), // Box border radius
                    ),
                    child: Text(
                      code,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ), // Space between code boxes and the button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff696DFF),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    // Button tap functionality
                  },
                  child: const Text('발급'), // The button text
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
