import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/services/roster_service.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/custom_list_container.dart';

class RostersDataTable extends StatelessWidget {
  final List<Roster> rosters;
  final Function(Roster) onRosterSelected;
  final RosterService _rosterService = RosterService();

  RostersDataTable({
    super.key,
    required this.rosters,
    required this.onRosterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Expanded(
        child: CustomListContainer(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Roster Name')),
              DataColumn(label: Text('Start Date')),
              DataColumn(label: Text('Published')),
              DataColumn(label: Text('Actions')),
            ],
            rows: rosters.map((roster) {
              return DataRow(cells: [
                DataCell(Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(roster.rosterName!),
                )),
                DataCell(Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(roster.startDate),
                )),
                DataCell(Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomElevatedButton(
                    text: roster.isPublished ? 'Published' : 'Private',
                    onPressed: () {
                      _rosterService.publishRoster(roster.rosterId!);
                    },
                  ),
                )),
                DataCell(Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            onRosterSelected(roster);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            print("Pretending to delete roster");
                            print(roster.rosterId);
                          },
                        ),
                      ],
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
