import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/services/user_auth_service.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/custom_formbuilder_text_field.dart';
import '../../../services/employee_service.dart';

class RegisterEmployee extends StatefulWidget {
  const RegisterEmployee({Key? key}) : super(key: key);

  @override
  _RegisterEmployeeState createState() => _RegisterEmployeeState();
}

class _RegisterEmployeeState extends State<RegisterEmployee> {
  final _formKeyRegisterEmployee = GlobalKey<FormBuilderState>();
  bool isSigningUp = false; // Define isSigningUp state

  Map<String, Map<String, String>> availability = {};

  final EmployeeService _employeeService = EmployeeService();
  final UserAuthProvider _authProvider = UserAuthProvider();

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
              _buildCreateEmployeeForm(),
              const SizedBox(height: defaultPadding),
              _buildEmployeeWeeklyAvailability(),
              const SizedBox(height: defaultPadding),
              CustomElevatedButton(
                text: 'Submit',
                onPressed: () {
                  _registerEmployee();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateEmployeeForm() {
    return FormBuilder(
      key: _formKeyRegisterEmployee,
      autovalidateMode: AutovalidateMode.disabled,
      child: const Column(
        children: [
          Text("Create Employee"),
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
            Text("Password: "),
            Expanded(
              child: CustomFormBuilderTextField(
                name: "password",
                hintText: "Enter your password",
              ),
            ),
          ]),
          SizedBox(height: defaultPadding),
          Row(children: [
            Text("How many days per week can you work: "),
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
                      value: availability[day]?['start_time'],
                      onChanged: (value) {
                        setState(() {
                          availability[day] ??= {};
                          availability[day]!['start_time'] = value!;
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
                      value: availability[day]?['end_time'],
                      onChanged: (value) {
                        setState(() {
                          availability[day] ??= {};
                          availability[day]!['end_time'] = value!;
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

  Future<void> _registerEmployee() async {
    if (_formKeyRegisterEmployee.currentState!.saveAndValidate()) {
      setState(() {
        isSigningUp = true;
      });

      var formData = _formKeyRegisterEmployee.currentState!.value;
      String firstName = formData['firstname'];
      String lastName = formData['lastname'];
      String email = formData['email'];
      String phoneNumber = formData['number'];
      String password = formData['password'];
      String daysPerWeek = formData['days_per_week'];

      try {
        // Create Firebase user and obtain user ID
        String userId = await _authProvider.createFirebaseDBUser(
            email, password, firstName);

        // Create employee object with obtained user ID
        Employee employee = Employee(
          firstName: firstName,
          lastName: lastName,
          daysPerWeek: int.parse(daysPerWeek),
          availability: availability
              .map((key, value) => MapEntry(key, value.cast<String, String>())),
          isAdmin: false,
          isDeleted: false,
          email: email,
          number: phoneNumber,
          businessId: buisnessID,
          id: userId, // Assign Firebase user ID as employee ID
        );

        // Call employee service to create employee
        await _employeeService.createEmployee(employee);

        // Reset form and availability
        _formKeyRegisterEmployee.currentState?.reset();
        setState(() {
          availability.clear();
        });
      } catch (error) {
        print('Error adding employee: $error');
      } finally {
        setState(() {
          isSigningUp = false;
        });
      }
    }
  }

  /*Future<String> _createFireBaseUser(String email, String password) async {
    setState(() {
      isSigningUp = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Successfully created user, return user ID
      String userId = userCredential.user!.uid;
      print('User ID: $userId');
      return userId;
    } catch (error) {
      print('Error creating Firebase user: $error');
      rethrow; // Rethrow the error to be caught by the caller
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }*/
}
