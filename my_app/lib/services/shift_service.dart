import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/shift.dart';

class ShiftService {
  static const String shiftsURI = "http://127.0.0.1:5000/shifts";

  Future<void> createShift(Shift shiftData) async {
    try {
      final response = await http.post(
        Uri.parse(shiftsURI),
        body: jsonEncode(shiftData.toJson()), // Use toJson here
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        print(
            'Shift added successfully with ID: ${jsonDecode(response.body)['id']}');
      } else {
        print('Failed to add shift. Error: ${response.body}');
      }
    } catch (error) {
      print('Error creating shift: $error');
    }
  }
}
