import 'package:flutter/material.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/services/roster_service.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/rosters/components/roster_display_widget.dart';

class GeneratedRosterScreen extends StatelessWidget {
  final Roster roster;
  final RosterService _rosterService = RosterService();
  String? rosterId;

  GeneratedRosterScreen(this.roster, {super.key});

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RosterDisplayWidget(roster),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  text: "Save Roster",
                  onPressed: () async {
                    rosterId = await _rosterService.saveRoster(roster);
                  },
                  textColor: Colors.white,
                ),
                CustomElevatedButton(
                  text: "Export Roster",
                  onPressed: () {
                    if (rosterId != null) {
                      _rosterService.exportRoster(roster);
                    } else {
                      print("Please save the roster first.");
                    }
                  },
                  textColor: Colors.white,
                ),
                const SizedBox(width: 20),
                CustomElevatedButton(
                  text: "Publish Roster",
                  onPressed: () {
                    if (rosterId != null) {
                      _rosterService.publishRoster(rosterId!);
                    } else {
                      print("Please save the roster first.");
                    }
                  },
                  textColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
