import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/shift.dart';

class ShiftService {
  static const String shiftsURI = "http://127.0.0.1:5000/shifts";

  Future<void> createShiftsList(List<Shift> shiftData) async {
    try {
      final List<Map<String, dynamic>> shiftsJsonList =
          shiftData.map((shift) => shift.toJson()).toList();

      final response = await http.post(
        Uri.parse(shiftsURI),
        body: jsonEncode(shiftsJsonList),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        print(
            'Shifts added successfully. Response: ${jsonDecode(response.body)}');
      } else {
        print('Failed to add shifts. Error: ${response.body}');
      }
    } catch (error) {
      print('Error creating shifts: $error');
    }
  }
}
