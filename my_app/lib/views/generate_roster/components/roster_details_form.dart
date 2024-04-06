import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/views/generate_roster/components/shift_input_form.dart';
import 'package:my_app/views/main/components/custom_elevated_button.dart';
import 'package:my_app/views/main/components/custom_formbuilder_text_field.dart';

class RosterDetailsForm extends StatefulWidget {
  final TextEditingController _rosterNameController;

  RosterDetailsForm(this._rosterNameController);

  @override
  _RosterDetailsFormState createState() => _RosterDetailsFormState();
}

class _RosterDetailsFormState extends State<RosterDetailsForm> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = _getNextMonday(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: CustomFormBuilderTextField(
              name: 'rosterName',
              hintText: 'Enter roster name',
              controller: widget._rosterNameController,
            ),
          ),
          SizedBox(width: defaultPadding),
          Expanded(
            flex: 2,
            child: CustomElevatedButton(
              height: 55.0,
              color: formInputColour,
              onPressed: () {
                _selectDate(context);
              },
              text:
                  'Starting Monday: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}',
              textColor: Colors.black,
            ),
          ),
          SizedBox(width: defaultPadding),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate:
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      selectableDayPredicate: (DateTime date) {
        return date.weekday == DateTime.monday;
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  DateTime _getNextMonday(DateTime date) {
    //in another file need to make common
    int daysUntilNextMonday = DateTime.monday - date.weekday;
    if (daysUntilNextMonday <= 0) {
      daysUntilNextMonday += 7;
    }
    return date.add(Duration(days: daysUntilNextMonday));
  }
}
