import 'package:flutter/material.dart';
import 'package:my_app/views/employees/components/employee_edit_widget.dart';
import 'package:my_app/views/main/components/custom_bottom_screen.dart';
import '../../../constants.dart';

class EmployeeList extends StatelessWidget {
  final List<Map<String, dynamic>> employees;

  const EmployeeList({Key? key, required this.employees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: listBgColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${employee['firstname']} ${employee['lastname']}',
                  style: const TextStyle(color: primaryTextColour),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email: ${employee['email']}',
                      style: const TextStyle(color: primaryTextColour),
                    ),
                    Text(
                      'Phone: ${employee['number']}',
                      style: const TextStyle(color: primaryTextColour),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    customModalBottomSheet(
                        context: context,
                        height: 700.0,
                        child: EditEmployee(employeeData: employee));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
