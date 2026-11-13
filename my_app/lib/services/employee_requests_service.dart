import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_request_model.dart';
import 'package:my_app/services/api_headers.dart';

class RequestService {
  static const String requestsEndpoint = '/requests';

  Future<void> createTimeOffRequest(TimeOffRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$APIURI$requestsEndpoint'),
        body: jsonEncode(request.toJson()),
        headers: await authenticatedHeaders(json: true),
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

  Future<List<TimeOffRequest>> getAllRequests(userId) async {
    try {
      print("DEBUG: Getting all requests for user:");
      print(userId);
      final response = await http.get(
        Uri.parse('$APIURI$requestsEndpoint'),
        headers: await authenticatedHeaders(),
      );

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
        Uri.parse('$APIURI$requestsEndpoint/approve/$requestId'),
        body: jsonEncode({'status': 'approved'}),
        headers: await authenticatedHeaders(json: true),
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
        Uri.parse('$APIURI$requestsEndpoint/deny/$requestId'),
        body: jsonEncode({'status': 'denied'}),
        headers: await authenticatedHeaders(json: true),
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
