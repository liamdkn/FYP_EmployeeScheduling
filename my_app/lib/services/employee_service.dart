import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';

class EmployeeService {
  String employeesEndpoint = "/employees";

  Future<void> createEmployee(Employee employee) async {
    try {
      final employeeData = employee.toJson();
      final response = await http.post(
        Uri.parse('$APIURI$employeesEndpoint'),
        body: jsonEncode(employeeData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        print(
            'Employee added successfully with ID: ${jsonDecode(response.body)['employee_id']}');
      } else {
        print(' 2Failed to add employee. Error: ${response.body}');
      }
    } catch (error, stackTrace) {
      print('Error creating employee: $error');
      print('Stack trace: $stackTrace');
    }
  }

  Future<Employee?> getEmployeeById(String employeeId) async {
    try {
      final response =
          await http.get(Uri.parse('$APIURI$employeesEndpoint/$employeeId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonEmployee = json.decode(response.body);

        if (jsonEmployee.containsKey('id')) {
          return Employee.fromJson(jsonEmployee);
        } else {
          print('Employee data is incomplete');
          return null;
        }
      } else {
        print('Failed to fetch employee. Error: ${response.body}');
        return null;
      }
    } catch (error, stackTrace) {
      print('Error fetching employee: $error');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<List<Employee>> getEmployees() async {
    final response = await http.get(Uri.parse('$APIURI$employeesEndpoint'));
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
      Uri.parse('$APIURI$employeesEndpoint/edit/$employeeId'),
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
      Uri.parse('$APIURI$employeesEndpoint/$employeeId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('Employee deleted successfully');
    } else {
      print('Failed to delete employee. Error: ${response.body}');
    }
  }

  Future<String?> getEmployeeNameById(String employeeId) async {
    try {
      final response =
          await http.get(Uri.parse('$APIURI$employeesEndpoint/$employeeId'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonEmployee = json.decode(response.body);

        if (jsonEmployee.containsKey('name')) {
          return jsonEmployee['name'];
        } else {
          print('Employee name not found');
          return null;
        }
      } else {
        print('Failed to fetch employee name. Error: ${response.body}');
        return null;
      }
    } catch (error, stackTrace) {
      print('Error fetching employee name: $error');
      print('Stack trace: $stackTrace');
      return null;
    }
  }
}
