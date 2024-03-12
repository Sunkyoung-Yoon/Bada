import 'package:flutter/material.dart';

class commonAppbar extends StatelessWidget {
  final String title;

  const commonAppbar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.white,
    );
  }
}
