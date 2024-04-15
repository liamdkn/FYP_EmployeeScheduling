import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/roster_model.dart';

class RosterService {
  static const String rosterURI = "http://127.0.0.1:5000/rosters";

  // Method to fetch assigned shifts for a roster
  Future<Roster> fetchRoster(String rosterId) async {
    try {
      final response = await http.get(Uri.parse('$rosterURI/$rosterId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> rosterData = jsonDecode(response.body);
        final Roster roster = Roster.fromJson(rosterData);
        return roster;
      } else {
        throw Exception(
            'Failed to fetch roster. Status Code: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      print('Error fetching roster: $error');
      throw Exception(
          'Error fetching rosters: $error\nStack Trace: $stackTrace');
    }
  }

  Future<List<Roster>> fetchAllRosters() async {
    try {
      final response = await http.get(Uri.parse(rosterURI));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> rosterDataList =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        final List<Roster> rosters = rosterDataList.map((rosterData) {
          return Roster.fromJson(rosterData);
        }).toList();
        return rosters;
      } else {
        throw Exception(
            'Failed to fetch rosters. Status Code: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      print('Error fetching rosters: $error');
      throw Exception(
          'Error fetching rosters: $error\nStack Trace: $stackTrace');
    }
  }

  Future<Roster> createRoster(
      Roster roster, String shiftId, List<String> employeeIds) async {
    print("DEBUG: Create roster service");

    try {
      final Map<String, dynamic> requestData = {
        'roster': roster.toJson(),
        'shifts_id': shiftId,
        'employee_ids': employeeIds,
      };

      final response = await http.post(
        Uri.parse(rosterURI),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 201) {
        print('Roster generated successfully');
        return Roster.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to generate roster. Status Code: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      print('Error generating roster: $error');
      print('Stack trace: $stackTrace');
      throw Exception('Error generating roster: $error');
    }
  }

  Future<void> exportRoster(Roster roster) async {
    print("DEBUG: Exporting roster service");
    try {
      final response = await http.post(
        Uri.parse('$rosterURI/export'),
        body: jsonEncode(roster.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Roster exported successfully');
      } else {
        throw Exception(
            'Failed to export roster. Status Code: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      print('Error exporting roster: $error');
      print(stackTrace);
      throw Exception('Error exporting roster: $error');
    }
  }

  Future<String> saveRoster(Roster roster) async {
    print("DEBUG: Saving roster service");
    try {
      final Map<String, dynamic> requestData = roster.toJson();

      final response = await http.post(
        Uri.parse('$rosterURI/save'),
        body: jsonEncode(requestData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String rosterId = responseData['roster_id'];
        print('Roster saved successfully with ID: $rosterId');
        return rosterId;
      } else {
        throw Exception(
            'Failed to save roster. Status Code: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      print('Error saving roster: $error');
      print(stackTrace);
      throw Exception('Error saving roster: $error');
    }
  }

  Future<void> publishRoster(String rosterId) async {
    print("DEBUG: Publishing roster service");
    try {
      final response = await http.put(
        Uri.parse('$rosterURI/publish/$rosterId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Roster published successfully');
      } else {
        throw Exception(
            'Failed to publish roster. Status Code: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      print('Error publishing roster: $error');
      print(stackTrace);
      throw Exception('Error publishing roster: $error');
    }
  }
}
