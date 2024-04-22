import 'package:flutter/material.dart';
import 'package:my_app/services/user_auth_service.dart';
import 'package:my_app/responsive.dart'; // Assuming you have a responsive.dart file

import 'package:provider/provider.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  //final String? userType;

  const SideMenu({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    //required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    String? userType = Provider.of<UserAuthProvider>(context).userType;

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text(
              "Roster",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard,
            press: () {
              onItemSelected(0);
            },
          ),
          DrawerListTile(
            title: "Rosters",
            icon: Icons.receipt_long,
            press: () {
              onItemSelected(1);
            },
          ),
          if (userType == 'business' && !Responsive.isMobile(context))
            DrawerListTile(
              title: "Generate Roster",
              icon: Icons.receipt_long_outlined,
              press: () {
                onItemSelected(2);
              },
            ),
          if (userType == 'business')
            DrawerListTile(
              title: "Employees",
              icon: Icons.people,
              press: () {
                onItemSelected(3);
              },
            ),
          DrawerListTile(
            title: "Requests",
            icon: Icons.three_p,
            press: () {
              onItemSelected(4);
            },
          ),
          if (userType == 'employee')
            DrawerListTile(
              title: "Profile",
              icon: Icons.person,
              press: () {
                onItemSelected(5);
              },
            ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
  });

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 10.0,
      leading: Icon(
        icon,
        color: Colors.white54,
        size: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
