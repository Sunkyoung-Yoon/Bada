import 'package:flutter/material.dart';

class PlaceDetail extends StatelessWidget {
  final String placeName;

  const PlaceDetail({super.key, required this.placeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placeName),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 50,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Text('이름: '),
                        InputChip(
                          label: Text(placeName),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text('주소: '),
                        InputChip(
                          label: Text('입력값 받을곳'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('수정'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('삭제'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
