import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final int width;
  final int height;

  const CustomElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width = 150,
    this.height = 45,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 35,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: secondaryTextColour),
        ),
      ),
    );
  }
}
