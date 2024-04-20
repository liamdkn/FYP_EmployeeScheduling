import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/services/employee_service.dart';
import 'package:my_app/views/employees/components/employee_edit_widget.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Employee>(
      future: _fetchEmployee(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final Employee employee = snapshot.data!;
          return SafeArea(
            child: SingleChildScrollView(
              primary: false,
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                children: [
                  Header(
                    title: 'Profile',
                  ),
                  SizedBox(height: defaultPadding),
                  Container(
                    height: 800,
                    child: EditEmployee(
                      employee: employee,
                      isBusinessUser: false,
                      onUpdate: () {},
                    ),
                  ),
                  SizedBox(height: defaultPadding),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Employee> _fetchEmployee() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final currentUser = _auth.currentUser;
    String userId = currentUser!.uid;
    EmployeeService _employeeService = EmployeeService();
    Employee? employee = await _employeeService.getEmployeeById(userId);
    return employee!;
  }
}
