import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/services/roster_service.dart'; // Import your roster service class

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: 'Dashboard',
            ),
            SizedBox(height: defaultPadding), // Add some space below the header
            // Rest of your content goes here...
          ],
        ),
      ),
    );
  }
}


/*
class DashboardScreen extends StatelessWidget {
  final RosterService rosterService =
      RosterService(); // Instantiate the roster service

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: 'Dashboard',
            ),
            SizedBox(height: defaultPadding),
            FutureBuilder(
              future: rosterService.fetchRoster(
                  '8bEnrIOgFiVZi28ejjke'), // Pass the roster id here
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Container(
                              child: RosterDisplayWidget(snapshot
                                  .data), // Pass the fetched roster to the widget
                            ),
                            SizedBox(height: defaultPadding),
                            Text("Requests"),
                            if (Responsive.isMobile(context))
                              SizedBox(height: defaultPadding),
                            if (Responsive.isMobile(context)) Text("Storage"),
                          ],
                        ),
                      ),
                      if (!Responsive.isMobile(context))
                        SizedBox(width: defaultPadding),
                      // On Mobile means if the screen is less than 850 we don't want to show it
                      if (!Responsive.isMobile(context))
                        Expanded(
                          flex: 2,
                          child: Text("Storage"),
                        ),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}*/
