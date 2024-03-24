import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';

void customModalBottomSheet({
  required BuildContext context,
  required Widget child,
  required double height,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: child,
        ),
      );
    },
  );
}
