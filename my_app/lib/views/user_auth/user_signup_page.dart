import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/business_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/services/business_service.dart';
import 'package:my_app/views/employees/components/employee_register_widget.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/custom_formbuilder_text_field.dart';
import 'package:my_app/views/main/components/custom_text_form_field.dart';
import 'package:my_app/services/user_auth_services.dart';
import 'package:my_app/views/user_auth/user_login_page.dart';

enum UserType { business, employee }

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final BusinessService _businessService = BusinessService();
  Map<String, Map<String, String>> availability = {};

  bool isSigningUp = false;
  UserType? userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormBuilder(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const Text("Register",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              _buildUserTypeSelector(),
              const SizedBox(height: defaultPadding),
              if (userType == UserType.business) _buildBusinessForm(),
              GestureDetector(
                onTap: createBusiness,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isSigningUp
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              _buildLoginPrompt(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeSelector() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomElevatedButton(
              text: 'New Business',
              onPressed: () {
                setState(() {
                  userType = UserType.business;
                });
              },
              width: 150,
              height: 45,
              color: userType == UserType.business ? Colors.blue : null,
            ),
            const SizedBox(width: defaultPadding),
            CustomElevatedButton(
              text: 'New Employee',
              onPressed: () {
                setState(() {
                  userType =
                      userType == UserType.employee ? null : UserType.employee;
                });
              },
              width: 150,
              height: 45,
              color: userType == UserType.employee ? Colors.blue : null,
            ),
          ],
        ),
        if (userType == UserType.employee)
          const SizedBox(
            height: 750.0,
            width: 700.0,
            child: RegisterEmployee(),
          ),
      ],
    );
  }

  Widget _buildBusinessForm() {
    List<String> times = generateHalfHourIntervals();

    return Column(
      children: [
        const CustomFormBuilderTextField(
            name: "businessName", hintText: "Business Name"),
        const SizedBox(height: defaultPadding),
        const CustomFormBuilderTextField(
            name: "buisnessNumber", hintText: "Business Phone Number"),
        const SizedBox(height: defaultPadding),
        const CustomFormBuilderTextField(
            name: "buisnessEmail", hintText: "Business Email Address"),
        const SizedBox(height: defaultPadding),
        FormBuilderDropdown(
          name: 'openingTime',
          decoration: const InputDecoration(
            labelText: 'Opening Time',
          ),
          items: times
              .map((time) => DropdownMenuItem(
                    value: time,
                    child: Text(time),
                  ))
              .toList(),
          onChanged: (val) {
            print(val);
          },
        ),
        const SizedBox(height: defaultPadding),
        FormBuilderDropdown(
          name: 'closingTime',
          decoration: const InputDecoration(
            labelText: 'Closing Time',
          ),
          items: times
              .map((time) => DropdownMenuItem(
                    value: time,
                    child: Text(time),
                  ))
              .toList(),
          onChanged: (val) {
            print(val);
          },
        ),
        const SizedBox(height: defaultPadding * 2),
        const CustomFormBuilderTextField(
            name: "buisnessPassword", hintText: "Account Password"),
      ],
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

  Widget _buildLoginPrompt(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account?"),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage(nextRoute: '/home')),
              (route) => false,
            );
          },
          child: const Text("Login",
              style:
                  TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Future<void> createBusiness() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        isSigningUp = true;
      });

      var formData = _formKey.currentState!.value;
      String businessName = formData['businessName'];
      String phoneNumber = formData['buisnessNumber'];
      String email = formData['buisnessEmail'];
      String openingTime = formData['openingTime'];
      String closingTime = formData['closingTime'];
      String password = formData['buisnessPassword'];

      try {
        // Create Firebase user and obtain user ID
        String userId = await _createFireBaseUser(email, password);

        // Create business object with obtained user ID
        Business business = Business(
          businessId: userId, // Assign Firebase user ID as business ID
          name: businessName,
          number: phoneNumber,
          email: email,
          openingTime: openingTime,
          closingTime: closingTime,
          isDeleted: false,
        );

        // Call business service to create business and get the ID
        String businessId = await _businessService.createBusiness(business);

        // Reset form and navigate to login page
        _formKey.currentState?.reset();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage(nextRoute: '/home')),
          (route) => false,
        );
      } catch (error) {
        print('Error creating business and admin employee: $error');
      } finally {
        setState(() {
          isSigningUp = false;
        });
      }
    }
  }

  Future<String> _createFireBaseUser(String email, String password) async {
    setState(() {
      isSigningUp = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;
      print('User ID: $userId');
      return userId;
    } catch (error) {
      print('Error creating Firebase user: $error');
      rethrow;
    } finally {
      setState(() {
        isSigningUp = false;
      });
    }
  }
}
