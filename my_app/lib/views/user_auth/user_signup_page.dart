import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/views/main/components/custom_text_form_field.dart';
import 'package:my_app/views/user_auth/user_auth_services.dart';
import 'package:my_app/views/user_auth/user_login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

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
              Text(
                "Register",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: defaultPadding),
              Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "First Name",
                      placeholder: "First Name",
                      controller: _firstNameController,
                    ),
                    SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "Last Name",
                      placeholder: "Last Name",
                      controller: _lastNameController,
                    ),
                    SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "Email",
                      placeholder: "Email",
                      controller: _emailController,
                    ),
                    SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "Password",
                      controller: _passwordController,
                      placeholder: "Password",
                    ),
                    SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "Phone Number",
                      controller: _phoneNumberController,
                      placeholder: "Phone Number",
                    ),
                    SizedBox(height: defaultPadding),
                    CustomTextFormField(
                      label: "Access Code", // Add access code field
                      controller: _accessCodeController,
                      placeholder: "Access Code",
                    ),
                    SizedBox(height: defaultPadding),
                    Row(
                      children: [
                        Text("Are you a: "),
                        SizedBox(width: defaultPadding),
                        DropdownButton<String>(
                          value: userType,
                          onChanged: (value) {
                            setState(() {
                              userType = value;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              child: Text("Employer"),
                              value: "employer",
                            ),
                            DropdownMenuItem(
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
              SizedBox(height: defaultPadding),
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
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  SizedBox(width: 5),
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
                    child: Text(
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
          // Fetch employer ID using access code
          String? employerId = await fetchEmployerId(accessCode);

          // Create employee object
          Employee employee = Employee(
            firstName: firstName,
            lastName: lastName,
            email: email,
            number: phoneNumber,
            daysPerWeek: 0,
            availability: {},
            isAdmin: false,
            isDeleted: false,
            employerId: employerId,
          );
        } else if (userType == "employer") {
          // mployer sign-up
        } else {
          //  no user type selected
        }
      } else {
        print('Error: User is null after signing up');
      }

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

  fetchEmployerId(String accessCode) {
    return "123";
  }
}
