 import 'package:flutter/material.dart';
import 'package:lista_tarefa/toDoList.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarFormat _calendarController;
  DateTime _focusDay = DateTime.now();
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendário', 
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.transparent,
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              calendarFormat: CalendarFormat.month, 
              focusedDay: _focusDay, 
              firstDay: DateTime(2000), 
              lastDay: DateTime(2100),
              onDaySelected: (selectedDay, focusedDay) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ToDoListPage(selectedDate: selectedDay)));
              },
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(
                  color: Colors.white
                ),
                weekendTextStyle: TextStyle(
                  color: Colors.white
                ),
                withinRangeTextStyle: TextStyle(
                  color: Colors.white
                )
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(
                  color: Colors.white
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
                formatButtonDecoration: BoxDecoration(
                  border: BoxBorder.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
              ),
            )
          ],
        ),
      )
    );
  }
}
