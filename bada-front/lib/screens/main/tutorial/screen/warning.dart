import 'package:flutter/material.dart';

class Warning extends StatelessWidget {
  const Warning({super.key});
  final String warnText = '''
  주의!
  '바래다줄게'는 Kakao 로컬 api를 활용한 건물 정보를 가져오며, 
  부정확하거나 시간이 지난 결과를 제공할 수도 있습니다.

  
''';
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
