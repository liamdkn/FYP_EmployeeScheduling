import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/services/roster_service.dart';
import 'package:my_app/views/rosters/components/roster_display_widget.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final RosterService _rosterService = RosterService();
  late Future<Roster?> _rosterFuture;

  @override
  void initState() {
    super.initState();
    _rosterFuture = _fetchCurrentRoster();
  }

  Future<Roster?> _fetchCurrentRoster() async {
    try {
      final Roster roster = await _rosterService.fetchRoster(currentRoster);
      return roster;
    } catch (error) {
      return null;
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
              title: 'Dashboard',
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            const Text(
              "Current Roster",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            FutureBuilder<Roster?>(
              future: _rosterFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Create your first roster to see it here!');
                } else if (snapshot.hasData) {
                  return RosterDisplayWidget(snapshot.data!);
                } else {
                  return const Text('No roster data available');
                }
              },
            ),
            // Add any other content here
          ],
        ),
      ),
    );
  }
}
