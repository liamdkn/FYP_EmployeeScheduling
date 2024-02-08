import 'package:flutter/material.dart';
import 'package:my_app/models/shift.dart';

class WeekViewWidget extends StatelessWidget {
  final List<Shift> shifts;
  final Function(Shift) onDeleteShift;

  const WeekViewWidget(
      {Key? key, required this.shifts, required this.onDeleteShift})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
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
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            children: [
              _buildDayView("Mon"),
              _buildDayView("Tue"),
              _buildDayView("Wed"),
              _buildDayView("Thu"),
              _buildDayView("Fri"),
              _buildDayView("Sat"),
              _buildDayView("Sun"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayView(String dayOfWeek) {
    List<Shift> shiftsForDay = shifts.where((shift) {
      return shift.daysOfWeek.containsKey(dayOfWeek) &&
          shift.daysOfWeek[dayOfWeek]!;
    }).toList();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: shiftsForDay.length,
            itemBuilder: (context, index) {
              Shift shift = shiftsForDay[index];
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(shift.name),
                    Text(
                      '${shift.startTime.format(context)} - ${shift.endTime.format(context)}',
                    ),
                    InkWell(
                      onTap: () {
                        onDeleteShift(shift);
                      },
                      child: Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
