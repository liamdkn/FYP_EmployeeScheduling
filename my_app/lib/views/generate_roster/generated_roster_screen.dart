import 'package:flutter/material.dart';
import 'package:my_app/models/roster_model.dart'; // Import the Roster model
import 'package:my_app/services/roster_service.dart';
import 'package:my_app/views/rosters/components/roster_display_widget.dart'; // Import the RosterService

class GeneratedRosterScreen extends StatefulWidget {
  final String rosterId; // roster ID
  const GeneratedRosterScreen(this.rosterId, {Key? key}) : super(key: key);

  @override
  _GeneratedRosterScreenState createState() => _GeneratedRosterScreenState();
}

class _GeneratedRosterScreenState extends State<GeneratedRosterScreen> {
  late Future<Roster> _rosterFuture;
  final RosterService _rosterService = RosterService();

  @override
  void initState() {
    super.initState();
    _rosterFuture = _fetchRoster();
  }

  Future<Roster> _fetchRoster() async {
    try {
      return _rosterService.fetchRoster(widget.rosterId);
    } catch (error) {
      throw Exception('Failed to fetch roster: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Roster'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: FutureBuilder<Roster>(
          future: _rosterFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return RosterDisplayWidget(snapshot.data!);
            } else {
              return Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
