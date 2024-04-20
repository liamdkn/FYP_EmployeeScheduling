import 'package:flutter/material.dart';
import 'package:my_app/models/employee_request_model.dart';
import 'package:my_app/services/employee_requests_service.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';

class EditRequest extends StatelessWidget {
  final TimeOffRequest request;
  final RequestService requestService = RequestService();
  final Function() onUpdate; // Add onUpdate parameter

  EditRequest({
    required this.request,
    required this.onUpdate, // Pass the onUpdate callback as a parameter
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
            style: Theme.of(context).textTheme.headline6,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
          ),
        ],
      ),
    );
  }
/*
  void _approveRequest(BuildContext context, String requestId) async {
    final currentContext = context;
    try {
      await requestService.approveTimeOffRequest(requestId);
      onUpdate();
      Navigator.pop(currentContext);
    } catch (error) {}
  }

  void _denyRequest(BuildContext context, String requestId) async {
    final currentContext = context;
    try {
      await requestService.denyTimeOffRequest(requestId);
      onUpdate();
      Navigator.pop(currentContext);
    } catch (error) {}
  }*/
}
