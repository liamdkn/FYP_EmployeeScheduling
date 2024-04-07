import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/models/employee_model.dart';

class EmployeeService {
  String employeesURI = "http://127.0.0.1:5000/employees";

  Future<void> createEmployee(Employee employee) async {
    final employeeData = employee.toJson();
    final response = await http.post(
      Uri.parse(employeesURI),
      body: jsonEncode(employeeData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      print(
          'Employee added successfully with ID: ${jsonDecode(response.body)['employee_id']}');
    } else {
      print('Failed to add employee. Error: ${response.body}');
    }
  }

  Future<List<Employee>> getEmployees() async {
    final response = await http.get(Uri.parse(employeesURI));
    print('Success Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);

      final List<Employee> employeeList = jsonList.map((dynamic json) {
        return Employee.fromJson(json);
      }).toList();

      return employeeList;
    } else {
      print('Failed to fetch employees. Error: ${response.body}');
      return [];
    }
  }

  Future<void> editEmployee(
      String employeeId, Map<String, dynamic> employeeData) async {
    final response = await http.put(
      Uri.parse('$employeesURI/$employeeId'),
      body: jsonEncode(employeeData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Employee edited successfully');
    } else {
      print('Failed to edit employee. Error: ${response.body}');
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    final response = await http.put(
      Uri.parse('$employeesURI/$employeeId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Employee deleted successfully');
    } else {
      print('Failed to delete employee. Error: ${response.body}');
    }
  }
}
