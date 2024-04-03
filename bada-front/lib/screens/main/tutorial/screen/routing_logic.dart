import 'dart:math';

import 'package:bada/widgets/appbar.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoutingLogic extends StatelessWidget {
  final List<String> imgList = [
    'assets/tutorial/20.png',
    'assets/tutorial/21.png',
    'assets/tutorial/22.png',
    'assets/tutorial/23.png',
    'assets/tutorial/24.png',
    'assets/tutorial/25.png',
    'assets/tutorial/26.png',
    'assets/tutorial/27.png',
    'assets/tutorial/28.png',
    'assets/tutorial/29.png',
    'assets/tutorial/30.png',
    'assets/tutorial/31.png',
    'assets/tutorial/32.png',
    'assets/tutorial/33.png',
    'assets/tutorial/34.png',
    'assets/tutorial/35.png',
  ];
  RoutingLogic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '경로 추천 원리',
      ),
      body: CarouselSlider(
        options: CarouselOptions(
          autoPlay: false,
          aspectRatio: 1, // You might need to adjust the aspect ratio
          enlargeCenterPage: true,
        ),
        items: imgList
            .map(
              (item) => Container(
                child: Center(
                  child: Image.asset(
                    item,
                    fit: BoxFit.cover,
                    width: 1000,
                    height: UIhelper.deviceHeight(context) * 0.22,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
