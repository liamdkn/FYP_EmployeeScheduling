import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/roster_model.dart';

class RosterList extends StatelessWidget {
  final List<Roster> rosters;

  const RosterList({Key? key, required this.rosters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: listBgColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: rosters.length,
        itemBuilder: (context, index) {
          final roster = rosters[index];
          final staticDate = '16/03/2024';
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Roster: ${roster.rosterId}',
                  style: const TextStyle(color: primaryTextColour),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: $staticDate',
                      style: const TextStyle(color: primaryTextColour),
                    ),
                    Text(
                      'Conflicts: ${roster.conflicts}',
                      style: const TextStyle(color: primaryTextColour),
                    ),
                    Text(
                      'Fitness: ${roster.fitness}',
                      style: const TextStyle(color: primaryTextColour),
                    ),
                    Text(
                      'Generations: ${roster.generations}',
                      style: const TextStyle(color: primaryTextColour),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
