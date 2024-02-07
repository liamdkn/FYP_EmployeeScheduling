import 'dart:convert';
import 'package:http/http.dart' as http;

class EmployeeService {
  String employeesURI = "http://127.0.0.1:5000/employees";

  Future<void> addEmployee(Map<String, dynamic> employeeData) async {
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
}
