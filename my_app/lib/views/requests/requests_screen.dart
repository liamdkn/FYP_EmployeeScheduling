import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_request_model.dart';
import 'package:my_app/services/employee_requests_service.dart';
import 'package:my_app/views/main/components/custom_bottom_screen.dart';
import 'package:my_app/views/main/components/custom_info_clicker.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/requests/components/requests_create_form.dart';
import 'package:my_app/views/requests/components/requests_table_widget.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List<TimeOffRequest> requests = [];
  final RequestService requestService = RequestService();

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  void fetchRequests() async {
    final List<TimeOffRequest>? requestList =
        await requestService.getAllRequests();
    if (requestList != null) {
      setState(() {
        requests = requestList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(
              title: 'Requests',
            ),
            const SizedBox(height: defaultPadding),
            Row(
              children: [
                _infoBoxes(context, requests),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(defaultPadding),
                width: double.infinity,
                child: RequestListTable(requests: requests),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _infoBoxes(BuildContext context, List<TimeOffRequest> requests) {
  int deniedCount =
      requests.where((request) => request.status == 'Denied').length;
  int pendingCount =
      requests.where((request) => request.status == 'Pending').length;
  int approvedCount =
      requests.where((request) => request.status == 'Approved').length;

  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: CustomInfoClicker(
              text: '$approvedCount approved requests',
              icon: Icons.check_circle,
              iconColour: Colors.green,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: CustomInfoClicker(
              text: '$pendingCount pending requests',
              icon: Icons.pending_actions,
              iconColour: Colors.yellow,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: CustomInfoClicker(
              text: '$deniedCount denied requests',
              icon: Icons.auto_delete,
              iconColour: Colors.red,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: CustomInfoClicker(
              text: 'Submit Request',
              icon: Icons.draw,
              iconColour: Colors.white,
              onPressed: () {
                customModalBottomSheet(
                  context: context,
                  height: 500.0,
                  child: const TimeOffRequestForm(),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
