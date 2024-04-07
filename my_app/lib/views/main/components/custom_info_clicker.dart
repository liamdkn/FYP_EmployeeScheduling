import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';

class CustomInfoClicker extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColour;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const CustomInfoClicker({
    required this.text,
    required this.icon,
    this.iconColour = primaryColor,
    required this.onPressed,
    this.width = 50.0,
    this.height = 150.0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40.0,
              color: iconColour,
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                color: thirdTextColour,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
