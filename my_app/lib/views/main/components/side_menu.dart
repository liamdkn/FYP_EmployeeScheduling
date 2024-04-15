import 'package:flutter/material.dart';
import 'package:my_app/views/rosters/roster_screen.dart';

class SideMenu extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SideMenu({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text("Roster Generator"),
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
          DrawerListTile(
            title: "Generate Roster",
            icon: Icons.receipt_long_outlined,
            press: () {
              onItemSelected(2);
            },
          ),
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
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

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
