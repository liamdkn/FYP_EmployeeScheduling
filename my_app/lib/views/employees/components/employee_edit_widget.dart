import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/custom_formbuilder_text_field.dart';
import '../../../services/employee_service.dart';

class EditEmployee extends StatefulWidget {
  final Employee employee;
  final Function() onUpdate;
  final bool isBusinessUser;

  const EditEmployee({
    Key? key,
    required this.employee,
    required this.onUpdate,
    required this.isBusinessUser,
  }) : super(key: key);

  @override
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  final GlobalKey<FormBuilderState> _formKeyEditEmployee =
      GlobalKey<FormBuilderState>();
  late Employee _editedEmployee;
  late Map<String, Map<String, String>> _editedAvailability;
  final EmployeeService _employeeService = EmployeeService();

  @override
  void initState() {
    super.initState();
    _editedEmployee = widget.employee;
    _editedAvailability = Map.from(widget.employee.availability);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildEditEmployeeForm(),
              const SizedBox(height: defaultPadding),
              _buildEmployeeWeeklyAvailability(),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.isBusinessUser)
                    CustomElevatedButton(
                      text: 'Delete',
                      onPressed: () async {
                        try {
                          await _employeeService
                              .deleteEmployee(_editedEmployee.id!);
                          widget.onUpdate();
                          Navigator.pop(context);
                        } catch (error) {
                          print('Error deleting employee: $error');
                        }
                      },
                      color: Colors.red,
                    ),
                  CustomElevatedButton(
                    text: widget.isBusinessUser
                        ? 'Save Changes'
                        : 'Update Profile',
                    onPressed: () async {
                      if (_formKeyEditEmployee.currentState!
                          .saveAndValidate()) {
                        Map<String, dynamic> updatedData = {
                          ..._formKeyEditEmployee.currentState!.value,
                          'days_per_week': int.parse(_formKeyEditEmployee
                              .currentState!.value['days_per_week']),
                          'availability': _editedAvailability,
                        };
                        try {
                          await _employeeService.editEmployee(
                              _editedEmployee.id!, updatedData);
                          widget.onUpdate();
                        } catch (error) {
                          print('Error updating employee: $error');
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditEmployeeForm() {
    return FormBuilder(
      key: _formKeyEditEmployee,
      initialValue: _editedEmployee.toJson()
        ..['days_per_week'] = _editedEmployee.daysPerWeek.toString(),
      autovalidateMode: AutovalidateMode.disabled,
      child: const Column(
        children: [
          Text("Edit Employee"),
          SizedBox(height: defaultPadding),
          Row(children: [
            Text("First Name: "),
            Expanded(
              child: CustomFormBuilderTextField(
                name: "firstname",
                hintText: "Joe",
              ),
            ),
            SizedBox(width: defaultPadding),
            Text("Surname: "),
            Expanded(
              child: CustomFormBuilderTextField(
                name: "lastname",
                hintText: "Bloggs",
              ),
            ),
          ]),
          SizedBox(height: defaultPadding),
          Row(children: [
            Text("Email: "),
            Expanded(
              child: CustomFormBuilderTextField(
                name: "email",
                hintText: "email@provider.com",
              ),
            ),
            SizedBox(width: defaultPadding),
            Text("Phone: "),
            Expanded(
              child: CustomFormBuilderTextField(
                name: "number",
                hintText: "0876543210",
              ),
            ),
          ]),
          SizedBox(height: defaultPadding),
          Row(children: [
            Text("Days Per Week: "),
            Expanded(
              child: CustomFormBuilderTextField(
                name: "days_per_week",
                hintText: "5",
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildEmployeeWeeklyAvailability() {
    return Column(
      children:
          daysOfWeek.map((day) => _buildDayAvailabilityColumn(day)).toList(),
    );
  }

  Widget _buildDayAvailabilityColumn(String day) {
    List<String> dropdownOptions = generateHalfHourIntervals();

    return Container(
      width: 350.0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                day,
                style: const TextStyle(color: primaryTextColour),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      value: _editedAvailability[day]?['start_time'],
                      onChanged: (value) {
                        setState(() {
                          _editedAvailability[day] ??= {};
                          _editedAvailability[day]!['start_time'] = value!;
                        });
                      },
                      dropdownColor: Colors.grey[200],
                      items: dropdownOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownButton<String>(
                      value: _editedAvailability[day]?['end_time'],
                      onChanged: (value) {
                        setState(() {
                          _editedAvailability[day] ??= {};
                          _editedAvailability[day]!['end_time'] = value!;
                        });
                      },
                      dropdownColor: Colors.grey[200],
                      items: dropdownOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: const TextStyle(color: primaryTextColour),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> generateHalfHourIntervals() {
    List<String> intervals = [];

    for (int hour = buisnessOpeningTime; hour < buisnessClosingTime; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        String formattedHour = hour.toString().padLeft(2, '0');
        String formattedMinute = minute.toString().padLeft(2, '0');
        intervals.add('$formattedHour:$formattedMinute');
      }
    }
    return intervals;
  }
}
