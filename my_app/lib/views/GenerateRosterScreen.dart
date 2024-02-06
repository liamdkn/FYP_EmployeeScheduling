import 'package:flutter/material.dart';
import 'package:my_app/widgets/ShiftRows.dart';
import 'package:my_app/widgets/weekView.dart';

class GenerateRosterScreen extends StatefulWidget {
  const GenerateRosterScreen({Key? key}) : super(key: key);

  @override
  _GenerateRosterScreenState createState() => _GenerateRosterScreenState();
}

class Shift {
  String shiftName = '';
  String selectedStartTime = '09:00 AM';
  String selectedEndTime = '05:00 PM';
  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  bool sunday = false;

  Map<String, dynamic> toMap() {
    return {
      'shiftName': shiftName,
      'selectedStartTime': selectedStartTime,
      'selectedEndTime': selectedEndTime,
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
    };
  }
}

class _GenerateRosterScreenState extends State<GenerateRosterScreen> {
  final List<Shift> shifts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Roster'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShiftRows(shifts: shifts),
            ],
          ),
        ),
      ),
    );
  }
}
