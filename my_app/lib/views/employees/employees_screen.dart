import 'package:flutter/material.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/views/employees/components/employee_register_widget.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/custom_bottom_screen.dart';
import 'package:my_app/services/employee_service.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/employees/components/employees_data_table.dart';
import '../../../constants.dart';

class EmployeesScreen extends StatefulWidget {
  @override
  _EmployeesScreenState createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final EmployeeService _employeeService = EmployeeService();
  List<Employee> _employees = [];

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    try {
      final List<Employee> employeeList = await _employeeService.getEmployees();

      if (mounted) {
        setState(() {
          _employees = employeeList;
        });
      }
    } catch (error, stackTrace) {
      print('Error in employee screen fetching employees: $error');
      print('Stack trace: $stackTrace');
    }
  }

  void _updateEmployeesList() {
    _fetchEmployees();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(
              title: 'Employees',
            ),
            const SizedBox(height: headerPadding),
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
                          height: 750.0,
                          child: SizedBox(
                            height: 750.0,
                            width: 700.0,
                            child: RegisterEmployee(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: EmployeesDataTable(
                    employees: _employees,
                    onUpdate: _updateEmployeesList,
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
