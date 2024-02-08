import 'package:flutter/material.dart';
import 'package:my_app/widgets/shift_week_tabs.dart';
import 'package:my_app/widgets/navbar.dart';
import 'package:my_app/widgets/shift_input_form.dart';
import 'package:my_app/widgets/styled_scaffold.dart';

class CreateRoster extends StatefulWidget {
  const CreateRoster({Key? key}) : super(key: key);

  @override
  _CreateRosterState createState() => _CreateRosterState();
}

class _CreateRosterState extends State<CreateRoster> {
  @override
  Widget build(BuildContext context) {
    return StyledScaffold(
      title: 'Create Roster',
      child: Column(
        children: [
          Expanded(
            child: WeekViewWidget(),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CreateRoster(),
  ));
}
