import 'package:flutter/material.dart';
import 'package:my_app/models/employee_request_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/views/main/components/custom_bottom_screen.dart';
import 'package:my_app/views/main/components/custom_list_container.dart';
import 'package:my_app/views/requests/components/requests_edit_widget.dart';

class RequestListTable extends StatelessWidget {
  final List<TimeOffRequest> requests;
  final Function() onUpdate;
  final String userType;

  const RequestListTable(
      {Key? key,
      required this.requests,
      required this.onUpdate,
      required this.userType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: CustomListContainer(
        child: DataTable(
          columns: [
            if (!Responsive.isMobile(context))
              const DataColumn(label: Text('Name')),
            if (!Responsive.isMobile(context))
              const DataColumn(label: Text('Reason')),
            if (!Responsive.isMobile(context))
              const DataColumn(label: Text('Start Date')),
            if (!Responsive.isMobile(context))
              const DataColumn(label: Text('End Date')),
            const DataColumn(label: Text('Status')),
            const DataColumn(label: Text(""))
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
              if (!Responsive.isMobile(context))
                DataCell(Text(request.employeeId)),
              if (!Responsive.isMobile(context))
                DataCell(Text(request.requestType)),
              if (!Responsive.isMobile(context))
                DataCell(Text(request.startDate)),
              if (!Responsive.isMobile(context))
                DataCell(Text(request.endDate)),
              if (!Responsive.isMobile(context))
                DataCell(
                  Text(
                    request.status,
                    style: TextStyle(color: statusColor),
                  ),
                ),
              if (Responsive.isMobile(context))
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
                        child: EditRequest(
                          request: request,
                          onUpdate: onUpdate,
                          userType: userType,
                        ),
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
