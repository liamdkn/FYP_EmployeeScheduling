import 'package:my_app/responsive.dart';
import 'package:flutter/material.dart';
import 'package:my_app/views/main/components/custom_bottom_screen.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/header_widget.dart';
import 'package:my_app/views/requests/components/requests_create_form.dart';
import 'package:my_app/views/requests/components/requests_table_widget.dart';
import '../../../constants.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(
              title: 'Requests',
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Container(
                        child: Text("Storage 1"),
                      ),
                      const SizedBox(height: defaultPadding),
                      Container(
                        child: RequestListTable(),
                      ),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) const Text("Storage 3"),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        CustomElevatedButton(
                          text: 'Submit Request',
                          onPressed: () {
                            customModalBottomSheet(
                                context: context,
                                height: 700.0,
                                child: const TimeOffRequestForm());
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
