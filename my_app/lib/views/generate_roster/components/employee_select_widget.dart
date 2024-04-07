import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/services/employee_service.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';

class EmployeeListWidget extends StatefulWidget {
  final Function(List<String>) onEmployeesSelected;
  const EmployeeListWidget({Key? key, required this.onEmployeesSelected})
      : super(key: key);

  @override
  _EmployeeListWidgetState createState() => _EmployeeListWidgetState();
}

class _EmployeeListWidgetState extends State<EmployeeListWidget> {
  List<String> _selectedEmployeeIds = []; // Store selected employee IDs here
  late Future<List<Employee>> _employeesFuture;
  bool _selectAll = false;

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
            return Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: listBorderColor,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey.shade200,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Select Available Employees',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        CustomElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (_selectAll) {
                                _selectedEmployeeIds.clear();
                              } else {
                                _selectedEmployeeIds = employees
                                    .map((employee) => employee.id!)
                                    .toList();
                              }
                              _selectAll = !_selectAll;
                            });
                            widget.onEmployeesSelected(_selectedEmployeeIds);
                          },
                          text: _selectAll ? 'Deselect All' : 'Select All',
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      Employee employee = employees[index];
                      return Container(
                        color: Colors.grey.shade200,
                        child: CheckboxListTile(
                          title: Text(
                            '${employee.firstName} ${employee.lastName}',
                            style: TextStyle(color: Colors.black),
                          ),
                          value: _selectedEmployeeIds.contains(employee.id),
                          onChanged: (value) {
                            setState(() {
                              if (value != null) {
                                if (value) {
                                  _selectedEmployeeIds.add(employee.id!);
                                } else {
                                  _selectedEmployeeIds.remove(employee.id!);
                                }
                                widget
                                    .onEmployeesSelected(_selectedEmployeeIds);
                              }
                            });
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No employees available'));
          }
        }
      },
    );
  }
}
