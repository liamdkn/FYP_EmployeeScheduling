class Employee {
  int id;
  List<WorkingDay> workingHours;

  Employee({required this.id, required this.workingHours});
}

class WorkingDay {
  String day;
  String startTime;
  String endTime;

  WorkingDay(
      {required this.day, required this.startTime, required this.endTime});
}

void main() {
  // Example usage
  Employee employee1 = Employee(
    id: 1,
    workingHours: [
      WorkingDay(day: 'Monday', startTime: '08:00 AM', endTime: '05:00 PM'),
      WorkingDay(day: 'Tuesday', startTime: '09:00 AM', endTime: '06:00 PM'),
      WorkingDay(day: 'Wednesday', startTime: '08:30 AM', endTime: '04:30 PM'),
      // Add more working days as needed
    ],
  );

  // Accessing employee information
  print('Employee ID: ${employee1.id}');
  print('Working Hours:');
  for (WorkingDay day in employee1.workingHours) {
    print('${day.day}: ${day.startTime} - ${day.endTime}');
  }
}
