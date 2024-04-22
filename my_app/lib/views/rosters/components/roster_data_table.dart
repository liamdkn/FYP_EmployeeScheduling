import 'package:flutter/material.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/services/roster_service.dart';
import 'package:my_app/services/user_auth_service.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/custom_list_container.dart';
import 'package:provider/provider.dart';

class RostersDataTable extends StatelessWidget {
  final List<Roster> rosters;
  final Function(Roster) onRosterSelected;
  final Function(String) onRosterDeleted;
  final RosterService _rosterService = RosterService();

  RostersDataTable({
    super.key,
    required this.rosters,
    required this.onRosterSelected,
    required this.onRosterDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final userType =
        Provider.of<UserAuthProvider>(context, listen: false).userType;
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: CustomListContainer(
        child: DataTable(
          columns: [
            const DataColumn(label: Text('Roster Name')),
            if (!isMobile) const DataColumn(label: Text('Start Date')),
            if (!isMobile) const DataColumn(label: Text('Published')),
            const DataColumn(label: Text('Actions')),
          ],
          rows: rosters.map((roster) {
            return DataRow(cells: [
              DataCell(Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(roster.rosterName!),
              )),
              if (!isMobile)
                DataCell(Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(roster.startDate),
                )),
              if (!isMobile)
                DataCell(Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () {
                          onRosterSelected(roster);
                        },
                      ),
                      if (userType == 'business')
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            _handleRosterDelete(roster.rosterId!);
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
    );
  }

  void _handleRosterDelete(String rosterId) {
    onRosterDeleted(rosterId);
  }
}
