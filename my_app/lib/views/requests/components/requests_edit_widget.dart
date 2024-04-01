import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/employee_request_model.dart';
import 'package:my_app/services/employee_requests_service.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';

class EditRequest extends StatelessWidget {
  final TimeOffRequest request;
  final RequestService requestService = RequestService();

  EditRequest({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request Details',
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: defaultPadding),
          Text('Employee ID: ${request.employeeId}'),
          Text('Request Type: ${request.requestType}'),
          Text('Reason: ${request.reason}'),
          Divider(),
          Text('Start Date: ${DateFormat("yyyy-MM-dd").format(request.startDate)}'),
          Text('End Date: ${DateFormat("yyyy-MM-dd").format(request.endDate)}'),
          Text('Status: ${request.status}'),
          const SizedBox(height: defaultPadding * 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity, // Expand the button to full width
                child: CustomElevatedButton(
                  onPressed: () {
                    _approveRequest(request.requestId!); // Pass requestId
                  },
                  text: 'Approve',
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16), // Add vertical spacing
              SizedBox(
                width: double.infinity, // Expand the button to full width
                child: CustomElevatedButton(
                  onPressed: () {
                    _denyRequest(request.requestId!); // Pass requestId
                  },
                  text: 'Deny',
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _approveRequest(String requestId) async {
    try {
      await requestService.approveTimeOffRequest(requestId); // Pass requestId
      
    } catch (error) {
      
    }
  }

  void _denyRequest(String requestId) async {
    try {
      await requestService.denyTimeOffRequest(requestId); // Pass requestId
      
    } catch (error) {
      
    }
  }
}
