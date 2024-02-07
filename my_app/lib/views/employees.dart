import 'package:flutter/material.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  List<Map<String, String>> employees = [
    // You will populate this list with data from your API
    {
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john@example.com',
      'phone': '123-456-7890'
    },
    // Add more employees as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Roster'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle add new employee button click
                    // You can navigate to the page to add a new employee here
                  },
                  child: Text('Add Employee'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Grey background color
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: employees.map((employee) {
                    return ListTile(
                      title: Text(
                          '${employee['firstName']} ${employee['lastName']}'),
                      subtitle: Text(
                          'Email: ${employee['email']}\nPhone: ${employee['phone']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Handle edit button click
                          // You can navigate to the edit employee page here
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
