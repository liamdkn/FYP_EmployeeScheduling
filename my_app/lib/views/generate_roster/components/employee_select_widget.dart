import 'package:flutter/material.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/services/employee_service.dart';

class EmployeeListWidget extends StatefulWidget {
  const EmployeeListWidget({Key? key}) : super(key: key);

  @override
  _EmployeeListWidgetState createState() => _EmployeeListWidgetState();
}

class _EmployeeListWidgetState extends State<EmployeeListWidget> {
  List<Employee> _selectedEmployees = [];
  late Future<List<Employee>> _employeesFuture;

  @override
  void initState() {
    super.initState();
    _employeesFuture = EmployeeService().getEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Employee>>(
      future: _employeesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Employee>? employees = snapshot.data;
          if (employees != null && employees.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: employees.length,
              itemBuilder: (context, index) {
                Employee employee = employees[index];
                return Container(
                  color: Colors.grey.shade200,
                  child: CheckboxListTile(
                    title: Text(
                      employee.firstName,
                      style: TextStyle(color: Colors.black),
                    ),
                    value: _selectedEmployees.contains(employee),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          if (value) {
                            _selectedEmployees.add(employee);
                          } else {
                            _selectedEmployees.remove(employee);
                          }
                        }
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No employees available'));
          }
        }
      },
    );
  }
}
