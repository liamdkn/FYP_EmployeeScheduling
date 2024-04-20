import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/controllers/MenuAppController.dart';
import 'package:my_app/responsive.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/services/user_auth_service.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  final String title;

  const Header({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: primaryTextColour),
          ),
        //if (!Responsive.isMobile(context)) //removed as shrinking header on movbil small
        Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const ProfileCard()
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayName = Provider.of<UserAuthProvider>(context).displayName;
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: Text(
              displayName ?? "Hello!", //default while user is loading
              style: const TextStyle(color: Colors.white),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: secondaryTextColour),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamed(context, "/login");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
