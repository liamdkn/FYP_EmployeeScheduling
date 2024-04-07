import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final double height;
  final double width;
  final TextEditingController? controller;
  final String? initialValue;

  const CustomTextFormField({
    required this.label,
    this.placeholder,
    this.height = 50.0,
    this.width = double.infinity,
    this.controller,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _textEditingController =
        controller ?? TextEditingController(text: initialValue);

    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          labelText: placeholder,
          filled: true,
          fillColor: listColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
