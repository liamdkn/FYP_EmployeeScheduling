import 'package:flutter/material.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/services/user_auth_service.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/rosters/components/roster_display_widget.dart';
import 'package:my_app/views/rosters/components/roster_data_table.dart';
import 'package:provider/provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchRosters();
    });
    selectedRoster = null;
  }

  // Fetch rosters
  Future<void> fetchRosters() async {
    final userType =
        Provider.of<UserAuthProvider>(context, listen: false).userType ??
            "employee";
    final List<Roster> fetchedRosters =
        await rosterService.fetchAllRosters(userType);

    if (fetchedRosters.isNotEmpty) {
      setState(() {
        rosters = fetchedRosters;
        selectedRoster = fetchedRosters[0];
      });
    }
  }

  void handleRosterDeleted(String rosterId) {
    rosterService.deleteRoster(rosterId);
    setState(() {
      rosters.removeWhere((roster) => roster.rosterId == rosterId);
      if (selectedRoster?.rosterId == rosterId) {
        selectedRoster = null;
      }
    });
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
              const Center(
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
                        RosterDisplayWidget(selectedRoster ?? rosters[0]),
                        const SizedBox(height: defaultPadding),
                        SizedBox(
                          width: double.infinity,
                          child: RostersDataTable(
                            rosters: rosters,
                            onRosterSelected: (roster) {
                              handleRosterSelected(roster);
                            },
                            onRosterDeleted: (rosterId) {
                              handleRosterDeleted(rosterId);
                            },
                          ),
                        ),
                        if (Responsive.isMobile(context))
                          const SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Callback function passing roster id
  void handleRosterSelected(Roster roster) {
    print('Selected Roster: ${roster.rosterId}');
    setState(() {
      selectedRoster = roster;
    });
  }
}
