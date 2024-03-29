import 'package:bada_kids_front/model/member.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberItemWidget extends StatelessWidget {
  final Member member;
  final String myName;
  const MemberItemWidget({
    super.key,
    required this.member,
    required this.myName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff7B79FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
        ),
        onPressed: () async {
          final Uri url = Uri(
            scheme: 'tel',
            path: "01024484265",
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text('전화걸기'),
                content: Text('${member.name}님에게 전화 거시겠나요?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog
                    },
                  ),
                  TextButton(
                    child: const Text('전화걸기'),
                    onPressed: () async {
                      Navigator.of(context)
                          .pop(); // Dismiss the dialog before trying to launch the URL
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        debugPrint(url.path);
                        debugPrint('Failed to place a call');
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 45,
              backgroundImage: member.profileUrl != null
                  ? NetworkImage(member.profileUrl!)
                  : Image.asset('assets/img/default_profile.png').image,
            ),
            Text(member.name),
            // Additional member details
          ],
        ),
      ),
    );
  }
}
