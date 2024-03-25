import 'package:flutter/material.dart';
import 'package:my_app/views/employees/components/employee_register_widget.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/employees/components/employee_edit_widget.dart';
import 'package:my_app/views/main/components/custom_bottom_screen.dart';
import 'package:my_app/services/employee_service.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/employees/components/employee_list_widget.dart';
import '../../../constants.dart';
import '../../responsive.dart';

class EmployeesScreen extends StatefulWidget {
  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final EmployeeService _employeeService = EmployeeService();
  List<Map<String, dynamic>> _employees = [];

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    try {
      final List<Map<String, dynamic>> employeeList =
          await _employeeService.getEmployees();

      if (mounted) {
        setState(() {
          _employees = employeeList;
        });
      }
    } catch (error) {
      print('Error fetching employees: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: 'Employees',
            ),
            SizedBox(height: headerPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomElevatedButton(
                      text: 'Create Employee',
                      onPressed: () {
                        customModalBottomSheet(
                            context: context,
                            height: 700.0,
                            child: RegisterEmployee());
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      EmployeeList(employees: _employees),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
