import 'package:flutter/material.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/rosters/components/roster_display_widget.dart';
import 'package:my_app/views/rosters/components/roster_list_widget.dart';
import 'package:my_app/views/rosters/components/roster_picker.dart';
import '../../../constants.dart';
import 'package:my_app/services/roster_service.dart';

class RosterScreen extends StatelessWidget {
  final RosterService rosterService = RosterService();

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
            FutureBuilder<List<Roster>>(
              future: rosterService.fetchAllRosters(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Roster>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final List<Roster>? rosters = snapshot.data;
                  if (rosters == null || rosters.isEmpty) {
                    return Center(child: Text('No rosters available.'));
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                              ),
                              child: RosterDisplayWidget(rosters[0]),
                            ),
                            SizedBox(height: defaultPadding),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.green,
                                ),
                              ),
                              child: RosterList(rosters: rosters),
                            ),
                            if (Responsive.isMobile(context))
                              SizedBox(height: defaultPadding),
                            if (Responsive.isMobile(context))
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                  ),
                                ),
                                child: Text("Storage 4"),
                              ),
                          ],
                        ),
                      ),
                      if (!Responsive.isMobile(context))
                        SizedBox(width: defaultPadding),
                      if (!Responsive.isMobile(context))
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.orange,
                              ),
                            ),
                            child: Text("Storage 3"),
                          ),
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
