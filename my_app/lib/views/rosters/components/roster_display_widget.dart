import 'package:flutter/material.dart';
import 'package:my_app/constants.dart';
import 'package:my_app/models/roster_model.dart';
import 'package:my_app/models/shift_model.dart';
import 'package:my_app/responsive.dart';
import 'package:my_app/views/rosters/components/shift_display_component.dart';

class RosterDisplayWidget extends StatelessWidget {
  final Roster roster;

  const RosterDisplayWidget(this.roster, {super.key});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return _buildMobileLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildShiftsForAllDays(),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Table(
            border: TableBorder.all(color: rosterOutline),
            children: [
              TableRow(
                decoration: const BoxDecoration(color: rosterHeader),
                children: [
                  for (var day in daysOfWeek)
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        child: Text(
                          day,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
              TableRow(
                children: [
                  for (var day in daysOfWeek)
                    TableCell(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ..._buildShiftsForDay(roster, day),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShiftsForAllDays() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: daysOfWeek
          .map(
            (day) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    day,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ..._buildShiftsForDay(roster, day),
              ],
            ),
          )
          .toList(),
    );
  }

  List<Widget> _buildShiftsForDay(Roster roster, String day) {
    List<IndividualShift> shiftsForDay =
        roster.assignedShifts.where((shift) => shift.day == day).toList();
    return shiftsForDay
        .map(
          (indShift) => Container(
            padding: const EdgeInsets.all(8.0),
            child: ShiftDisplayComponent(indShift),
          ),
        )
        .toList();
  }
}
