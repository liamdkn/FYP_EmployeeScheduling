import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/employee_request_model.dart';
import 'package:my_app/services/employee_requests_service.dart';
import 'package:intl/intl.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/custom_formbuilder_dropdown.dart';
import 'package:my_app/views/main/components/custom_formbuilder_text_field.dart';

class TimeOffRequestForm extends StatefulWidget {
  const TimeOffRequestForm({Key? key}) : super(key: key);

  @override
  _TimeOffRequestFormState createState() => _TimeOffRequestFormState();
}

class _TimeOffRequestFormState extends State<TimeOffRequestForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  final RequestService _requestService = RequestService();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      skipDisabled: true,
      child: Column(
        children: [
          const Text(
            "Time Off Request",
            style: TextStyle(color: primaryTextColour),
          ),
          const SizedBox(height: defaultPadding),
          _buildSubmitRequestForm(),
          const SizedBox(height: defaultPadding),
          _buildDateTimePickers(),
          const SizedBox(height: defaultPadding * 2),
          CustomElevatedButton(
            onPressed: _submitForm,
            text: 'Submit',
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitRequestForm() {
    return Column(
      children: [
        CustomFormBuilderDropdown(
          name: 'requestType',
          hintText: 'Request Type',
          initialValue: '',
          items: holidayRequestReasons,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        CustomFormBuilderTextField(
          name: 'reason',
          hintText: 'Reason',
        ),
        const SizedBox(height: 16),
        FormBuilderCheckbox(
          name: 'isEmergency',
          title: const Text(
            'Emergency Request',
            style: TextStyle(color: primaryTextColour),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePickers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date & Time',
          style: TextStyle(
            fontSize: 16,
            color: primaryTextColour,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FormBuilderDateTimePicker(
                name: 'startDateTime',
                decoration: InputDecoration(
                  labelText: 'Start Date & Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: formInputColour,
                  labelStyle: const TextStyle(color: primaryTextColour),
                ),
                inputType: InputType.both,
                format: DateFormat("yyyy-MM-dd HH:mm"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FormBuilderDateTimePicker(
                name: 'endDateTime',
                decoration: InputDecoration(
                  labelText: 'End Date & Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: formInputColour,
                  labelStyle: const TextStyle(color: primaryTextColour),
                ),
                inputType: InputType.both,
                format: DateFormat("yyyy-MM-dd HH:mm"),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.saveAndValidate()) {
      Map<String, dynamic> formData = _formKey.currentState!.value;

      TimeOffRequest employeeRequest = TimeOffRequest(
        employeeId: 'frontend',
        startDate: formData['startDateTime'],
        endDate: formData['endDateTime'],
        isAllDay: false,
        requestType: formData['requestType'],
        reason: formData['reason'],
        status: 'Pending',
        isEmergency: formData['isEmergency'] ?? false,
        submissionDate: DateTime.now(),
        isDeleted: false,
      );

      _requestService.createTimeOffRequest(employeeRequest);

      _formKey.currentState!.reset();
    }
  }
}
