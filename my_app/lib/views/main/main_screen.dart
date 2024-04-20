//21/03/2024

import 'package:my_app/controllers/MenuAppController.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/services/user_auth_service.dart';
import 'package:my_app/views/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:my_app/views/generate_roster/generate_roster_screen.dart';
import 'package:my_app/views/profile/profile_screen.dart';
import 'package:my_app/views/rosters/roster_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_app/views/main/components/side_menu.dart';

import '../employees/employees_screen.dart';
import '../requests/requests_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MenuAppController>().setScaffoldKey(_scaffoldKey);
  }

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? userType = Provider.of<UserAuthProvider>(context).userType;

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(
        selectedIndex: _selectedIndex,
        onItemSelected: _onMenuItemSelected,
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(
                  selectedIndex: _selectedIndex,
                  onItemSelected: _onMenuItemSelected,
                ),
              ),
            Expanded(
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
        return ProfileScreen();
      default:
        return DashboardScreen();
    }
  }
}
