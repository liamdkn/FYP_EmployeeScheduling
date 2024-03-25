import 'package:flutter/material.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/rosters/components/roster_display_widget.dart';
import 'package:my_app/views/rosters/components/roster_list_widget.dart';
import 'package:my_app/views/rosters/components/roster_picker.dart';
import '../../../constants.dart';

class RosterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: 'Roster',
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        child: RosterDisplayWidget(),
                      ),
                      SizedBox(height: defaultPadding),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                        ),
                        child: RosterList(),
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                          ),
                          child: Text("Storage 4"),
                        ),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Text("Storage 3"),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
