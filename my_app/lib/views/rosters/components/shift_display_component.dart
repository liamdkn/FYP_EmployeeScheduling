import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/shift_model.dart';

class ShiftDisplayComponent extends StatelessWidget {
  final IndividualShift shift;

  ShiftDisplayComponent(this.shift, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: shiftBgColor,
        border: Border.all(color: shiftBorderColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shift.name,
          ),
          const SizedBox(height: 4.0),
          Text(
              "${shift.startTime.substring(0, 5)} - ${shift.endTime.substring(0, 5)}"),
          if (shift.employee != null)
            Text("${shift.employee!.firstName} ${shift.employee!.lastName}"),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ],
      ),
    );
  }
}
