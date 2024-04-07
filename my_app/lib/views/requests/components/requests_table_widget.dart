import 'package:flutter/material.dart';
import 'package:my_app/models/employee_request_model.dart';
import 'package:my_app/views/main/components/custom_bottom_screen.dart';
import 'package:my_app/views/main/components/custom_list_container.dart';
import 'package:my_app/views/requests/components/requests_edit_widget.dart';

class RequestListTable extends StatelessWidget {
  final List<TimeOffRequest> requests;

  RequestListTable({Key? key, required this.requests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: CustomListContainer(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Reason')),
            DataColumn(label: Text('Start Date')),
            DataColumn(label: Text('End Date')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text("")),
          ],
          rows: requests.map((request) {
            Color statusColor;
            switch (request.status) {
              case 'Pending':
                statusColor = Colors.orange;
                break;
              case 'Approved':
                statusColor = Colors.green;
                break;
              case 'Denied':
                statusColor = Colors.red;
                break;
              default:
                statusColor = Colors.black;
            }

            return DataRow(cells: [
              DataCell(Text(request.employeeId)),
              DataCell(Text(request.requestType)),
              DataCell(Text(request.startDate)),
              DataCell(Text(request.endDate)),
              DataCell(
                Text(
                  request.status,
                  style: TextStyle(color: statusColor),
                ),
              ),
              DataCell(
                SizedBox(
                  width: 40,
                  child: IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () {
                      customModalBottomSheet(
                        context: context,
                        height: 450.0,
                        child: EditRequest(request: request),
                      );
                    },
                  ),
                ),
              ),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
