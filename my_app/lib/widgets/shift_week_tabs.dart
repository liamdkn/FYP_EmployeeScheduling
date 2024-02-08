import 'package:flutter/material.dart';

class WeekViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Week View'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Sun'),
              Tab(text: 'Mon'),
              Tab(text: 'Tue'),
              Tab(text: 'Wed'),
              Tab(text: 'Thu'),
              Tab(text: 'Fri'),
              Tab(text: 'Sat'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Sunday')),
            Center(child: Text('Monday')),
            Center(child: Text('Tuesday')),
            Center(child: Text('Wednesday')),
            Center(child: Text('Thursday')),
            Center(child: Text('Friday')),
            Center(child: Text('Saturday')),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WeekViewWidget(),
  ));
}
