import 'package:flutter/material.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/roster_create.dart';
import 'package:my_app/views/rosters/components/roster_display_widget.dart';
import 'package:my_app/views/rosters/components/rosters_table_widget.dart';
import 'package:my_app/views/rosters/components/roster_picker.dart';
import 'package:my_app/widgets/shift_week_tabs.dart';
import '../../../constants.dart';
import 'package:my_app/services/roster_service.dart';

class RosterScreen extends StatefulWidget {
  @override
  _RosterScreenState createState() => _RosterScreenState();
}

class _RosterScreenState extends State<RosterScreen> {
  final RosterService rosterService = RosterService();
  late Roster? selectedRoster;
  List<Roster> rosters = [];

  @override
  void initState() {
    super.initState();
    // Initialize selectedRoster as null initially
    fetchRosters(); // Fetch rosters and initialize selectedRoster in initState
    selectedRoster = null;
  }

  // Fetch rosters
  Future<void> fetchRosters() async {
    final List<Roster>? fetchedRosters = await rosterService.fetchAllRosters();
    if (fetchedRosters != null && fetchedRosters.isNotEmpty) {
      setState(() {
        rosters = fetchedRosters;
        selectedRoster = fetchedRosters[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(
              title: 'Roster',
            ),
            const SizedBox(height: defaultPadding),
            if (rosters.isEmpty)
              Center(
                child: CircularProgressIndicator(),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Container(
                          child:
                              RosterDisplayWidget(selectedRoster ?? rosters[0]),
                        ),
                        const SizedBox(height: defaultPadding),
                        Container(
                          child: RosterTable(
                            rosters: rosters,
                            onRosterSelected: (roster) {
                              handleRosterSelected(roster);
                            },
                          ),
                        ),
                        if (Responsive.isMobile(context))
                          const SizedBox(height: defaultPadding),
                        if (Responsive.isMobile(context))
                          Container(
                            child: const Text("Storage 4"),
                          ),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    const SizedBox(width: defaultPadding),
                  if (!Responsive.isMobile(context))
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: CustomElevatedButton(
                          text: 'Generate Roster',
                          height: 45,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateRoster()),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Define the callback function to handle roster selection
  void handleRosterSelected(Roster roster) {
    print('Selected Roster: ${roster.rosterId}');
    setState(() {
      selectedRoster = roster;
    });
  }
}
