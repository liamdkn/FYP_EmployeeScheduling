import 'package:flutter/material.dart';

class CustomListContainer extends StatelessWidget {
  final Widget child;

  const CustomListContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }
}
