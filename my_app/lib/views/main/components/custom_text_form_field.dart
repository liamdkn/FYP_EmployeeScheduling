import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_app/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final double height;
  final double width;
  final Key? key;

  const CustomTextFormField({
    required this.label,
    this.placeholder,
    this.height = 50.0,
    this.width = double.infinity,
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FormBuilderTextField(
        name: label,
        style: const TextStyle(
          fontSize: 16.0,
          color: primaryTextColour,
        ),
        decoration: InputDecoration(
          labelText: placeholder,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
