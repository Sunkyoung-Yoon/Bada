import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino icons for the iOS back arrow

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return AppBar(
      title: Text(title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        iconSize: deviceWidth * 0.1,
        icon: const Icon(CupertinoIcons.back), // iOS style back arrow
        onPressed: () => Navigator.of(context).pop(), // Pop the current route
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Define the AppBar's height
}
