import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/business_model.dart';
import 'package:my_app/models/employee_model.dart';
import 'package:my_app/services/business_service.dart';
import 'package:my_app/services/employee_service.dart';
import 'package:http/http.dart' as http;

class UserAuthProvider extends ChangeNotifier {
  static const String userEndpoint = "/user";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmployeeService _employeeService = EmployeeService();
  final BusinessService _businessService = BusinessService();

  User? _user;
  String? _userType;
  Business? _business;
  Employee? _employee;
  String? _displayName;

  User? get user => _user;
  String? get userType => _userType;
  Business? get business => _business;
  Employee? get employee => _employee;
  String? get displayName => _displayName;

  UserAuthProvider() {
    _auth.authStateChanges().listen((user) => setUserAndType(user));
  }

  Future<void> setUserAndType(User? user) async {
    print("Setting user and type");
    if (user != null) {
      print('User is not null');
      _user = user;
      _userType = await getUserType(user.uid);
      print("User type has finished await:");
      print(_userType);
      if (_userType != null) {
        print("The user type is not null. Fetching user data...");
        _fetchUserData(user.uid, _userType!);
        print("User data fetched");
      }
    } else {
      print("User is null");
      _user = null;
      _userType = null;
      _business = null;
      _employee = null;
      _displayName = null;
    }
    notifyListeners();
  }

  Future<String?> getUserType(String? userId) async {
    print("Getting the type for user: ");
    final response = await http.get(Uri.parse('$APIURI$userEndpoint/$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body)['user_type'];
    }
    return null;
  }

  void _fetchUserData(String userId, String userType) async {
    if (userType == 'business') {
      print("getting buisness data");
      _business = await _businessService.getBusinessById(userId);
      _displayName = _business!.name;
      print(_displayName);
    } else if (userType == 'employee') {
      print("getting employee data");
      _employee = await _employeeService.getEmployeeById(userId);
      _displayName = _employee!.firstName;
      print("employee data got");
      print(_displayName);
    } else {
      print("DEBUG: your fucked");
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      throw e;
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(displayName);
      await user?.reload();
    } catch (e) {
      print("Error updating display name: $e");
      throw e;
    }
  }

  Future<String> createFirebaseDBUser(
      String email, String password, String displayName) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await updateDisplayName(displayName);

      String userId = userCredential.user!.uid;
      print('User ID: $userId');
      return userId;
    } catch (e) {
      print("Error registering user: $e");
      throw e;
    }
  }
}
