import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/services/api_headers.dart';

class EmployeeService {
  String employeesEndpoint = "/employees";

  Future<void> createEmployee(Employee employee) async {
    try {
      final employeeData = employee.toJson();
      final response = await http.post(
        Uri.parse('$APIURI$employeesEndpoint'),
        body: jsonEncode(employeeData),
        headers: await authenticatedHeaders(json: true),
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
      final response = await http.get(
        Uri.parse('$APIURI$employeesEndpoint/$employeeId'),
        headers: await authenticatedHeaders(),
      );

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
    final response = await http.get(
      Uri.parse('$APIURI$employeesEndpoint'),
      headers: await authenticatedHeaders(),
    );
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
      headers: await authenticatedHeaders(json: true),
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
      headers: await authenticatedHeaders(json: true),
    );

    if (response.statusCode == 200) {
      print('Employee deleted successfully');
    } else {
      print('Failed to delete employee. Error: ${response.body}');
    }
  }

  Future<String?> getEmployeeNameById(String employeeId) async {
    try {
      final response = await http.get(
        Uri.parse('$APIURI$employeesEndpoint/$employeeId'),
        headers: await authenticatedHeaders(),
      );

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

  Future<bool> checkAvailability(IndividualShift shift) async {
    try {
      Employee? employee = shift.employee;

      if (employee != null) {
        Map<String, dynamic> requestData = {
          'employee': employee.toJson(),
          'shift': shift.toJson(),
        };

        final response = await http.post(
          Uri.parse('$APIURI/employees/avacheck'),
          body: jsonEncode(requestData),
          headers: await authenticatedHeaders(json: true),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> data = jsonDecode(response.body);
          bool isAvailable = data['is_available'];
          return isAvailable;
        } else {
          print('Failed to check availability. Error: ${response.body}');
          return false;
        }
      } else {
        print('Employee not found in the shift');
        return false;
      }
    } catch (error, stackTrace) {
      print('Error checking availability: $error');
      print('Stack trace: $stackTrace');
      return false;
    }
  }
}
