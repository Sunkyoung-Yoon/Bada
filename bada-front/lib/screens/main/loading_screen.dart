import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          // home: FutureBuilder(
          //   future: initializeApp(),
          //   builder: (context, snapshot) {
          //     // Check if the future is completed
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       // Return the main screen if initialization is complete
          //       return const HomeScreen(); // Your main screen widget
          //     } else {
          //       // Return the loading screen while waiting
          //       return const LoadingScreen();
          //     }
          //   },
          // ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF9E88FF).withOpacity(0.18), // Bottom-right color
                const Color(0xFF83A3FF), // Top-left color
                // You can add more colors for a more complex gradient
              ],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 150,
                ),
                const Text(
                  '바래다줄게',
                  style: TextStyle(
                    color: Color(0xff7B79FF),
                    fontSize: 34,
                    // fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 130,
                ),
                Image.asset(
                  'assets/img/whistle.png',
                  width: 200,
                ),
                const SizedBox(
                  height: 130,
                ),
                const Text(
                  '우리 아이',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'Spoqa',
                  ),
                ),
                const Text(
                  '안심 귀가',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          )),
    );
  }
}
