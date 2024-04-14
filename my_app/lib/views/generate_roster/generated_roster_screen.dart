import 'package:flutter/material.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/services/roster_service.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/rosters/components/roster_display_widget.dart';

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
          icon: const Icon(Icons.arrow_back),
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
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RosterDisplayWidget(snapshot.data!),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomElevatedButton(
                        text: "Save Roster",
                        onPressed: () {
                          _rosterService.saveRoster(widget.rosterId);
                        },
                        textColor: Colors.white,
                      ),
                      CustomElevatedButton(
                        text: "Export Roster",
                        onPressed: () {
                          _rosterService.exportRoster(widget.rosterId);
                        },
                        textColor: Colors.white,
                      ),
                      const SizedBox(width: 20),
                      CustomElevatedButton(
                        text: "Publish Roster",
                        onPressed: () {
                          _rosterService.publishRoster(widget.rosterId);
                        },
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
