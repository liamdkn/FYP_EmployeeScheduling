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
        print("made it here 1");
        final Roster roster = Roster.fromJson(rosterData);
        print("roster parsed");
        return roster;
      } else {
        throw Exception(
            'Failed to fetch roster. Status Code: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      print('Error fetching roster: $error');
      print(stackTrace);
      throw Exception('Error fetching roster: $error');
    }
  }

  Future<List<Roster>> fetchAllRosters() async {
    try {
      final response = await http.get(Uri.parse(rosterURI));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> rosterDataList =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        print(response.body);
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
      print(stackTrace);
      throw Exception(
          'Error fetching rosters: $error\nStack Trace: $stackTrace');
    }
  }
}
