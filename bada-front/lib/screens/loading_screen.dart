import 'package:bada/models/screen_size.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    Provider.of<ScreenSizeModel>(context, listen: false).screenWidth =
        screenSize.width;
    Provider.of<ScreenSizeModel>(context, listen: false).screenHeight =
        screenSize.height;
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
                height: UIhelper.scaleHeight(context) * 150,
              ),
              const Text(
                '바래다줄게',
                style: TextStyle(
                  color: Color(0xff7B79FF),
                  fontSize: 34,
                ),
              ),
              SizedBox(
                height: UIhelper.scaleHeight(context) * 130,
              ),
              Image.asset(
                'assets/img/whistle.png',
                width: UIhelper.scaleWidth(context) * 200,
              ),
              SizedBox(
                height: UIhelper.scaleHeight(context) * 130,
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
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               const Color(0xFF9E88FF).withOpacity(0.18),
//               const Color(0xFF83A3FF),
//             ],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 150,
//               ),
//               const Text(
//                 '바래다줄게',
//                 style: TextStyle(
//                   color: Color(0xff7B79FF),
//                   fontSize: 34,
//                   // fontWeight: FontWeight.w900,
//                 ),
//               ),
//               const SizedBox(
//                 height: 130,
//               ),
//               Image.asset(
//                 'assets/img/whistle.png',
//                 width: 200,
//               ),
//               const SizedBox(
//                 height: 130,
//               ),
//               const Text(
//                 '우리 아이',
//                 style: TextStyle(
//                   fontSize: 24,
//                   color: Colors.white,
//                   fontFamily: 'Spoqa',
//                 ),
//               ),
//               const Text(
//                 '안심 귀가',
//                 style: TextStyle(
//                   fontSize: 24,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
