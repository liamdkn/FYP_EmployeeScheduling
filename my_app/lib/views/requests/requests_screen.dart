import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_request_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/services/employee_requests_service.dart';
import 'package:my_app/services/user_auth_service.dart';
import 'package:my_app/views/main/components/custom_bottom_screen.dart';
import 'package:my_app/views/main/components/custom_info_clicker.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/requests/components/requests_create_form.dart';
import 'package:my_app/views/requests/components/requests_table_widget.dart';
import 'package:provider/provider.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  late String userId;
  List<TimeOffRequest> requests = [];
  final RequestService requestService = RequestService();

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserAuthProvider>(context, listen: false).user!.uid;
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
    final List<TimeOffRequest> requestList =
        await requestService.getAllRequests(userId);
    setState(() {
      requests = requestList;
    });
  }

  void _updateRequestsList() {
    _fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    String? userType = Provider.of<UserAuthProvider>(context).userType;

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
                Visibility(
                  visible: Responsive.isMobile(context),
                  child: _infoBoxesNarrow(context, requests, userType!),
                ),
              ],
            ),
            Visibility(
              visible: !Responsive.isMobile(context),
              child: _infoBoxesWide(context, requests, userType!),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(defaultPadding),
                width: double.infinity,
                child: RequestListTable(
                  requests: requests,
                  onUpdate: () {
                    _updateRequestsList();
                  },
                  userType: 'business',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBoxesNarrow(
    BuildContext context,
    List<TimeOffRequest> requests,
    String userType,
  ) {
    int deniedCount =
        requests.where((request) => request.status == 'Denied').length;
    int pendingCount =
        requests.where((request) => request.status == 'Pending').length;
    int approvedCount =
        requests.where((request) => request.status == 'Approved').length;
    int emergencyCount =
        requests.where((request) => request.isEmergency == true).length;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          children: [
            Row(
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
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: CustomInfoClicker(
                    text: '$deniedCount denied requests',
                    icon: Icons.auto_delete,
                    iconColour: Colors.red,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 6),
                if (userType == 'business')
                  Expanded(
                    child: CustomInfoClicker(
                      text: '$emergencyCount emergency requests',
                      icon: Icons.warning,
                      iconColour: Color.fromARGB(255, 250, 149, 26),
                      onPressed: () {},
                    ),
                  ),
                if (userType == 'employee')
                  Expanded(
                    child: CustomInfoClicker(
                      text: 'Submit Request',
                      icon: Icons.draw,
                      iconColour: Colors.white,
                      onPressed: () {
                        customModalBottomSheet(
                          context: context,
                          height: 500.0,
                          child: TimeOffRequestForm(
                            userId: userId,
                            onSubmit: () {
                              _updateRequestsList();
                            },
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoBoxesWide(
      BuildContext context, List<TimeOffRequest> requests, String userType) {
    int deniedCount =
        requests.where((request) => request.status == 'Denied').length;
    int pendingCount =
        requests.where((request) => request.status == 'Pending').length;
    int approvedCount =
        requests.where((request) => request.status == 'Approved').length;
    int emergencyCount =
        requests.where((request) => request.isEmergency == true).length;

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
            if (userType == 'business')
              Expanded(
                child: CustomInfoClicker(
                  text: '$emergencyCount emergency requests',
                  icon: Icons.warning,
                  iconColour: Color.fromARGB(255, 250, 149, 26),
                  onPressed: () {},
                ),
              ),
            const SizedBox(width: 6),
            if (userType == 'employee')
              Expanded(
                child: CustomInfoClicker(
                  text: 'Submit Request',
                  icon: Icons.draw,
                  iconColour: Colors.white,
                  onPressed: () {
                    customModalBottomSheet(
                      context: context,
                      height: 500.0,
                      child: TimeOffRequestForm(
                        userId: userId,
                        onSubmit: () {
                          _updateRequestsList();
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
