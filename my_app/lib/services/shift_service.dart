import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/constants.dart';
import 'package:my_app/models/shift_model.dart';

class ShiftService {
  static const String shiftsEndpoint = "/shifts";

  Future<String> createShifts(List<IndividualShift> shifts) async {
    try {
      List<Map<String, dynamic>> shiftsJsonList =
          shifts.map((shift) => shift.toJson()).toList();

      final response = await http.post(
        Uri.parse('$APIURI$shiftsEndpoint'),
        body: jsonEncode(shiftsJsonList),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final String shiftIds = responseData['shifts_id'];
        print('Shifts added successfully. IDs: $shiftIds');
        return shiftIds;
      } else {
        print('Failed to add shifts. Error: ${response.body}');
        return "";
      }
    } catch (error) {
      print('Error creating shifts: $error');
      throw error;
    }
  }
}
