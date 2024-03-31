//21/03/2024

import 'package:my_app/controllers/MenuAppController.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/views/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:my_app/views/generate_roster/generate_roster_screen.dart';
import 'package:my_app/views/rosters/roster_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_app/views/main/components/side_menu.dart';

import '../employees/employees_screen.dart';
import '../requests/requests_screen.dart';
import '../settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(
        selectedIndex: _selectedIndex,
        onItemSelected: _onMenuItemSelected,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(
                  selectedIndex: _selectedIndex,
                  onItemSelected: _onMenuItemSelected,
                ),
              ),
            Expanded(
              // takes 5/6 part of the screen
              flex: 5,
              child: _buildSelectedScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return DashboardScreen();
      case 1:
        return RosterScreen();
      case 2:
        return GenerateRosterScreen();
      case 3:
        return EmployeesScreen();
      case 4:
        return RequestsScreen();
      case 5:
        return Text("Profile Screen");
      case 6:
        return SettingsScreen();
      default:
        return DashboardScreen();
    }
  }
}
