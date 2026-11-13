import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: constant_identifier_names
const String APIURI = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:5000',
);

const primaryColor = Color.fromARGB(255, 255, 0, 204);
const secondaryColor = Color.fromRGBO(37, 35, 42, 1.0);
const bgColor = Color(0xFFF5F5F5);

const primaryTextColour = Color.fromARGB(255, 0, 0, 0);
const secondaryTextColour = Color.fromARGB(255, 255, 255, 255);
const thirdTextColour = Color.fromARGB(180, 169, 169, 165);

//Employee get fn
const Color listColor = Color.fromARGB(133, 218, 218, 218);
const Color listHeaderColor = Color.fromARGB(255, 200, 200, 200);
const Color listBorderColor = Color.fromARGB(255, 77, 77, 77);

const Color shiftBgColor = Color.fromARGB(255, 167, 191, 236);
const Color shiftBorderColor = Color.fromARGB(86, 98, 137, 215);

const Color formInputColour = Color.fromRGBO(238, 238, 238, 1);

const Color rosterHeader = Color.fromARGB(60, 122, 120, 127);
const Color rosterOutline = Color.fromARGB(185, 122, 120, 127);

const defaultPadding = 16.0;
const headerPadding = 55.0;

const List<String> daysOfWeek = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const int buisnessOpeningTime = 8;
const int buisnessClosingTime = 18;

const viewIcon = Icon(Icons.remove_red_eye);

const List<String> holidayRequestReasons = [
  'Holiday',
  'Illness',
  'Family Matter',
  'College Reason',
  'Other'
];

const buisnessID = "CIhEwAyPzWXz8d9e9QexHTlLqTr2";
const currentRoster = "YD6eJHf00YXEsHu3OZc0";

List<String> generateHalfHourIntervals() {
  List<String> intervals = [];

  for (int hour = buisnessOpeningTime; hour < buisnessClosingTime; hour++) {
    for (int minute = 0; minute < 60; minute += 30) {
      String formattedHour = hour.toString().padLeft(2, '0');
      String formattedMinute = minute.toString().padLeft(2, '0');
      intervals.add('$formattedHour:$formattedMinute');
    }
  }
  return intervals;
}

String currentDateAsString() {
  return DateFormat('dd-MM-yyyy').format(DateTime.now());
}
