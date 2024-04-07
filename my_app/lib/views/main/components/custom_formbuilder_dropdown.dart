import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_app/constants.dart';

class CustomFormBuilderDropdown extends StatelessWidget {
  final String name;
  final List<String> items;
  final String initialValue;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final void Function(String?)? onChanged;

  const CustomFormBuilderDropdown({
    Key? key,
    required this.name,
    required this.items,
    required this.initialValue,
    required this.hintText,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      name: name,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(color: primaryTextColour),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
        filled: true,
        fillColor: formInputColour,
      ),
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Container(
            height: 50,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              item,
              style: TextStyle(color: secondaryTextColour),
            ),
          ),
        );
      }).toList(),
    );
  }
}
