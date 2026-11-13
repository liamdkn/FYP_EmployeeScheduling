import 'package:flutter/material.dart';
import 'package:my_app/models/employee_request_model.dart';
import 'package:my_app/services/employee_requests_service.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';

class EditRequest extends StatelessWidget {
  final TimeOffRequest request;
  final RequestService requestService = RequestService();
  final Function() onUpdate;
  final String userType;

  EditRequest({
    required this.request,
    required this.onUpdate,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: defaultPadding),
          Text('Employee ID: ${request.employeeId}'),
          Divider(),
          Text('Request Type: ${request.requestType}'),
          Text('Reason: ${request.reason}'),
          Divider(),
          Text('Start Date: ${request.startDate}'),
          Text('End Date: ${request.endDate}'),
          Divider(),
          Text('Status: ${request.status}'),
          const SizedBox(height: defaultPadding * 2),
          //approve and deny only for business users
          if (userType == "business") ...[
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: () {
                  //_approveRequest(context, request.requestId!);
                  requestService.approveTimeOffRequest(request.requestId!);
                  onUpdate();
                  Navigator.pop(context);
                },
                text: 'Approve',
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: () {
                  //_denyRequest(context, request.requestId!);
                  requestService.denyTimeOffRequest(request.requestId!);
                  onUpdate();
                  Navigator.pop(context);
                },
                text: 'Deny',
                color: Colors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
