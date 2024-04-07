import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/employee_request_model.dart';

class RequestService {
  static const String baseUrl = 'http://127.0.0.1:5000/requests';

  Future<void> createTimeOffRequest(TimeOffRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode(request.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        print('Time-off request submitted successfully');
      } else {
        throw Exception('Failed to submit time-off request');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<List<TimeOffRequest>> getAllRequests() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> requestData = json.decode(response.body);
        List<TimeOffRequest> requests = [];

        for (var json in requestData) {
          TimeOffRequest request = TimeOffRequest.fromJson(json);
          request.requestId = json['request_id'];
          requests.add(request);
        }

        return requests;
      } else {
        throw Exception('Failed to load requests');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> approveTimeOffRequest(String requestId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/approve/$requestId'),
        body: jsonEncode({'status': 'approved'}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Request approved successfully');
      } else {
        throw Exception('Failed to approve request');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Future<void> denyTimeOffRequest(String requestId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/deny/$requestId'),
        body: jsonEncode({'status': 'denied'}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Request denied successfully');
      } else {
        throw Exception('Failed to deny request');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
