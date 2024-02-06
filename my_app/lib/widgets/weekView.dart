/*
* Author: Liam Durkan 
* Date:
* Licence: GPL3
* Brief: This class uses flutters tab controler to represent the days of the week, showing the shifts passed from the shift-rows form. 
* 
*/

import 'package:flutter/material.dart';

class WeekViewScreen extends StatefulWidget {
  final List<Map<String, dynamic>> formData;

  const WeekViewScreen({Key? key, required this.formData}) : super(key: key);

  @override
  _WeekViewScreenState createState() => _WeekViewScreenState();
}

class _WeekViewScreenState extends State<WeekViewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Week View'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          margin: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Mon'),
                  Tab(text: 'Tue'),
                  Tab(text: 'Wed'),
                  Tab(text: 'Thu'),
                  Tab(text: 'Fri'),
                  Tab(text: 'Sat'),
                  Tab(text: 'Sun'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    buildDayView('monday'),
                    buildDayView('tuesday'),
                    buildDayView('wednesday'),
                    buildDayView('thursday'),
                    buildDayView('friday'),
                    buildDayView('saturday'),
                    buildDayView('sunday'),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle adding a new shift
                  setState(() {
                    widget.formData.add({
                      'shiftName': 'New Shift',
                      'selectedStartTime': '08:00 AM',
                      'selectedEndTime': '05:00 PM',
                      // Add other properties as needed
                    });
                  });
                },
                child: Text('Add Shift'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDayView(String day) {
    // Filter the form data for the selected day
    List<Map<String, dynamic>> shiftsForDay = widget.formData
        .where((shift) => shift[day.toLowerCase()] == true)
        .toList();

    return ListView.builder(
      itemCount: shiftsForDay.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> shiftData = shiftsForDay[index];

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: shiftData['shiftName'],
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    labelText: 'Shift Name',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8.0,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              DropdownButton<String>(
                value: shiftData['selectedStartTime'],
                onChanged: (value) {},
                items: [
                  '08:00 AM',
                  '09:00 AM',
                  '10:00 AM',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(width: 16.0),
              DropdownButton<String>(
                value: shiftData['selectedEndTime'],
                onChanged: (value) {
                  // Handle end time change
                  // Update the form data accordingly
                },
                items: [
                  '05:00 PM', '06:00 PM', '07:00 PM', // Add your times
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(width: 16.0),
              TextButton(
                onPressed: () {
                  // Handle shift removal
                  /*setState(() {
                    widget.formData.remove(shiftData);
                  });*/
                },
                child: Text('Remove'),
              ),
            ],
          ),
        );
      },
    );
  }
}
