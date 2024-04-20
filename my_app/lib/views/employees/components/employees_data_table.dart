import 'package:flutter/material.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/views/employees/components/employee_edit_widget.dart';
import 'package:my_app/views/main/components/custom_bottom_screen.dart';
import 'package:my_app/views/main/components/custom_list_container.dart';
import '../../../constants.dart';

class EmployeesDataTable extends StatelessWidget {
  final List<Employee> employees;
  final Function() onUpdate;

  const EmployeesDataTable(
      {Key? key, required this.employees, required this.onUpdate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: CustomListContainer(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Phone Num.')),
            DataColumn(label: Text('Days Per Week')),
            DataColumn(label: Text('')),
          ],
          rows: employees.map((employee) {
            return DataRow(cells: [
              DataCell(Text('${employee.firstName} ${employee.lastName}')),
              DataCell(Text(employee.email)),
              DataCell(Text(employee.number)),
              DataCell(Text(employee.daysPerWeek.toString())),
              DataCell(
                IconButton(
                  icon: viewIcon,
                  onPressed: () {
                    customModalBottomSheet(
                      context: context,
                      height: 750.0,
                      child: EditEmployee(
                        employee: employee,
                        onUpdate: onUpdate,
                        isBusinessUser: true,
                      ),
                    );
                  },
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
