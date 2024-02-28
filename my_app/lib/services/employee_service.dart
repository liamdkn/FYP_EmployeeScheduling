import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployeeService {
  String employeesURI = "http://127.0.0.1:5000/employees";

  Future<void> createEmployee(Map<String, dynamic> employeeData) async {
    print("Got to employee service");
    final response = await http.post(
      Uri.parse(employeesURI),
      body: jsonEncode(employeeData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      print(
          'Employee added successfully with ID: ${jsonDecode(response.body)['id']}');
    } else {
      print('Failed to add employee. Error: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getEmployees() async {
    final response = await http.get(Uri.parse(employeesURI));

    print('Success Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      final List<Map<String, dynamic>> employeeList =
          jsonList.map((dynamic json) {
        return {
          'avalability': json['avalability'],
          'firstname': json['firstname'],
          'lastname': json['lastname'],
          'email': json['email'],
          'number': json['number']
        };
      }).toList();
      return employeeList;
    } else {
      print('Failed to fetch employees. Error: ${response.body}');
      return [];
    }
  }
}
