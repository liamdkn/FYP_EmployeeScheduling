import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/roster_model.dart';

class RosterList extends StatelessWidget {
  final List<Roster> rosters;
  final Function(Roster) onRosterSelected;

  const RosterList({
    Key? key,
    required this.rosters,
    required this.onRosterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: listColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rosters.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Roster',
                          style: TextStyle(color: primaryTextColour),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Roster Period',
                          style: TextStyle(color: primaryTextColour),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Conflicts',
                          style: TextStyle(color: primaryTextColour),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Generations',
                          style: TextStyle(color: primaryTextColour),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            final roster = rosters[index - 1];
            final startDate = '16/03/2024';
            final endDate = '23/03/2024';

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          roster.rosterId,
                          style: const TextStyle(color: primaryTextColour),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          startDate + " - " + endDate,
                          style: const TextStyle(color: primaryTextColour),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          ' ${roster.conflicts} detected',
                          style: const TextStyle(color: primaryTextColour),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${roster.generations}',
                          style: const TextStyle(color: primaryTextColour),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      onRosterSelected(roster);
                    },
                    icon: Icon(Icons.remove_red_eye),
                    color: secondaryColor,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
