import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_request_model.dart';

class RequestService {
  static const String requestsEndpoint = '/requests';

  Future<void> createTimeOffRequest(TimeOffRequest request) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final userId = _auth.currentUser?.uid;
    try {
      final response = await http.post(
        Uri.parse('$APIURI$requestsEndpoint'),
        body: jsonEncode(request.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'User-id': userId!,
        },
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
      final Map<String, String> headers = {
        'User-id': userId,
      };
      final response = await http.get(
        Uri.parse('$APIURI$requestsEndpoint'),
        headers: headers,
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
        Uri.parse('$APIURI$requestsEndpoint/deny/$requestId'),
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
