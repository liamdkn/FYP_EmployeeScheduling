import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_app/constants.dart';

class CustomFormBuilderTextField extends StatelessWidget {
  final String name;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;

  const CustomFormBuilderTextField({
    Key? key,
    required this.name,
    this.hintText,
    this.validator,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: name,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: primaryTextColour),
        filled: true,
        fillColor: formInputColour,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: listBorderColor),
        ),
      ),
      keyboardType: TextInputType.text,
      validator: validator,
      controller: controller,
    );
  }
}
