import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneCall extends StatelessWidget {
  const PhoneCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: ElevatedButton(
            child: const Text('전화테스트'),
            onPressed: () async {
              final Uri url = Uri(
                scheme: 'tel',
                path: "010 2448 4265",
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              } else {
                print('씨빨');
              }
            },
          ),
        ),
      ),
    );
  }
}
