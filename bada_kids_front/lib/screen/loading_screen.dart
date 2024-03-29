import 'package:bada_kids_front/model/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    // Provider.of<ScreenSizeModel>(context, listen: false).screenWidth =
    //     screenSize.width;
    // Provider.of<ScreenSizeModel>(context, listen: false).screenHeight =
    //     screenSize.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF9E88FF).withOpacity(0.18),
              const Color(0xFF83A3FF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: deviceHeight * 0.15,
              ),
              const Text(
                '바래다줄게',
                style: TextStyle(
                  color: Color(0xff7B79FF),
                  fontSize: 34,
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.125,
              ),
              Stack(
                children: [
                  Lottie.asset(
                    'assets/lottie/walking-cloud.json',
                    width: deviceWidth * 0.7,
                  ),
                  Lottie.asset(
                    'assets/lottie/walking-pencil.json',
                    width: deviceWidth * 0.7,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
