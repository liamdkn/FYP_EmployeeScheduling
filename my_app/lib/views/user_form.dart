import 'package:flutter/material.dart';
import 'package:my_app/views/employee_register.dart';
import 'package:my_app/widgets/styled_scaffold.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  _userFormState createState() => _userFormState();
}

class _userFormState extends State<UserForm> {
  @override
  Widget build(BuildContext context) {
    return StyledScaffold(
      title: 'Generate Roster',
      child: RegisterEmployee(),
    );
  }
}
