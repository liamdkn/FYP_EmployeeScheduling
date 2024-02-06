/*
* SidenNavBar flutter package sourced from: https://pub.dev/packages/side_navigation
*/
import 'package:flutter/material.dart';
import 'package:my_app/views/GenerateRosterScreen.dart';
import 'package:my_app/views/RegisterEmployee.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:my_app/views/CreateRoster.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<NavBar> {
  List<Widget> views = [
    const Center(
      child: Text("Home"),
    ),
    Center(
      child: GenerateRosterScreen(),
    ),
    Center(
      child: CreateRoster(),
    ),
    Center(
      child: RegisterEmployee(),
    ),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigationBar(
            header: SideNavigationBarHeader(
              image: CircleAvatar(
                child: Icon(Icons.account_balance),
              ),
              title: Text('Employee Scheduler'), //title
              subtitle: Text(''), //subtitle
            ),
            footer: SideNavigationBarFooter(label: Text('')), //footer
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Home',
              ),
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'Roster V1',
              ),
              SideNavigationBarItem(
                icon: Icons.settings,
                label: 'Roster V2',
              ),
              SideNavigationBarItem(
                icon: Icons.person,
                label: 'Employees',
              ),
            ],
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: views.elementAt(selectedIndex),
          )
        ],
      ),
    );
  }
}

class ShiftListWidget {}
