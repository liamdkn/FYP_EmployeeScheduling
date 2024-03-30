import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_request_model.dart';
import 'package:my_app/services/employee_requests_service.dart';

class RequestListTable extends StatelessWidget {
  final RequestService requestService = RequestService();

  RequestListTable({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TimeOffRequest>>(
      future: requestService.getAllRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<TimeOffRequest>? requests = snapshot.data;
          if (requests != null && requests.isNotEmpty) {
            return Container(
              color: listColor,
              padding: const EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Reason')),
                  DataColumn(label: Text('Start Date')),
                  DataColumn(label: Text('End Date')),
                  DataColumn(label: Text('Status')),
                ],
                rows: requests.map((request) {
                  return DataRow(cells: [
                    DataCell(Text(request.employeeId)),
                    DataCell(Text(request.requestType)),
                    DataCell(Text(
                        '${request.startDate.day}-${request.startDate.month}-${request.startDate.year}')),
                    DataCell(Text(
                        '${request.endDate.day}-${request.endDate.month}-${request.endDate.year}')),
                    DataCell(Text(request.status)),
                  ]);
                }).toList(),
              ),
            );
          } else {
            return const Center(child: Text('No requests available'));
          }
        }
      },
    );
  }
}
