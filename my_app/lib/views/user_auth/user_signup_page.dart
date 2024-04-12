import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/business_model.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/services/business_service.dart';
import 'package:my_app/services/employee_service.dart';
import 'package:my_app/views/main/components/custom_text_form_field.dart';
import 'package:my_app/services/user_auth_services.dart';
import 'package:my_app/views/user_auth/user_login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final EmployeeService employeeService = EmployeeService();
  final BusinessService businessService = BusinessService();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _accessCodeController = TextEditingController();

  bool isSigningUp = false;

  String? userType;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    _accessCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Register",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: defaultPadding),
              Container(
                padding: const EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "First Name",
                      placeholder: "First Name",
                      controller: _firstNameController,
                    ),
                    const SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "Last Name",
                      placeholder: "Last Name",
                      controller: _lastNameController,
                    ),
                    const SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "Email",
                      placeholder: "Email",
                      controller: _emailController,
                    ),
                    const SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "Password",
                      controller: _passwordController,
                      placeholder: "Password",
                    ),
                    const SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "Phone Number",
                      controller: _phoneNumberController,
                      placeholder: "Phone Number",
                    ),
                    const SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "Access Code", // Add access code field
                      controller: _accessCodeController,
                      placeholder: "Access Code",
                    ),
                    const SizedBox(height: defaultPadding),
                    Row(
                      children: [
                        const Text("Are you a: "),
                        const SizedBox(width: defaultPadding),
                        DropdownButton<String>(
                          value: userType,
                          onChanged: (value) {
                            setState(() {
                              userType = value;
                            });
                          },
                          items: [
                            const DropdownMenuItem(
                              child: Text("New Employer"),
                              value: "business",
                            ),
                            const DropdownMenuItem(
                              child: Text("Employee"),
                              value: "employee",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              GestureDetector(
                onTap: _signUp,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isSigningUp
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(nextRoute: '/home'),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String phoneNumber = _phoneNumberController.text;
    String password = _passwordController.text;
    String accessCode = _accessCodeController.text;

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        String userId = user.uid;
        print('User ID: $userId');

        if (userType == "employee") {
          String buisnessId = buisnessID;

          Employee employee = Employee(
            id: userId,
            firstName: firstName,
            lastName: lastName,
            email: email,
            number: phoneNumber,
            daysPerWeek: 0,
            availability: {},
            isAdmin: false,
            isDeleted: false,
            businessId: buisnessId,
          );

          employeeService.createEmployee(employee);
        } else if (userType == "business") {
          Business business = Business(
            name: firstName,
            number: phoneNumber,
            email: email,
            openingHours: {},
            isDeleted: false,
          );

          String businessId = await businessService.createBusiness(business);

          // admin employee tied to the business
          Employee adminEmployee = Employee(
            id: userId,
            firstName: firstName,
            lastName: lastName,
            email: email,
            number: phoneNumber,
            daysPerWeek: 0,
            availability: {},
            isAdmin: true,
            isDeleted: false,
            businessId: businessId,
          );

          employeeService.createEmployee(adminEmployee);
        } else {
          //  no user type selected
        }
      } else {
        print('Error: User is null after signing up');
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(
            email: email,
            password: password,
          ),
        ),
        (route) => false,
      );

      setState(() {
        isSigningUp = false;
      });
    } catch (error) {
      print('Error signing up: $error');
      setState(() {
        isSigningUp = false;
      });
    }
  }
}
