import 'package:my_app/services/employee_service.dart';
import 'package:my_app/views/employee_register.dart';
import 'package:flutter/material.dart';
import 'package:my_app/widgets/styled_scaffold.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  final EmployeeService _employeeService = EmployeeService();
  List<Map<String, dynamic>> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final List<Map<String, dynamic>> employeeList =
          await _employeeService.getEmployees();

      setState(() {
        employees = employeeList;
      });
    } catch (error) {
      print('Error fetching employees: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StyledScaffold(
        title: "Employees",
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to RegisterEmployee screen when the button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterEmployee()),
                    );
                  },
                  child: Text('Add Employee'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Grey background color
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: employees.map((employee) {
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${employee['firstname']} ${employee['lastname']}'),
                          Text('Email: ${employee['email']}'),
                          Text('Phone: ${employee['number']}'),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Handle edit button click
                              // You can navigate to the edit employee page here
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ));
  }
}
