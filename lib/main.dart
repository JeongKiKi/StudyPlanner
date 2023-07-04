import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'todo_service.dart';

late SharedPreferences prefs;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

typedef OnDaySelected = void Function(
    DateTime selectedDay, DateTime focusedDay);

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  List<Todo> todoList = [
    Todo(content: '새 메모 1', done: false), // 더미(dummy) 데이터
    Todo(content: '새 메모 2', done: false), // 더미(dummy) 데이터
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('투두리스트'),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // 첫 번째 액션 버튼을 눌렀을 때 실행할 동작을 정의하세요.
              // 예: 데이터 삭제 기능
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              // 두 번째 액션 버튼을 눌렀을 때 실행할 동작을 정의하세요.
              // 예: 할 일 추가 기능
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2021, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.week,
            onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
                this.focusedDay = focusedDay;
              });
            },
            selectedDayPredicate: (DateTime day) {
              return isSameDay(selectedDay, day);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                Todo todoItem = todoList[index];
                return ListTile(
                  title: Text(todoItem.content),
                  trailing: Checkbox(
                    value: todoItem.done,
                    onChanged: (value) {
                      setState(() {
                        todoItem.done = value!;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Todo {
  final String content;
  bool done;

  Todo({
    required this.content,
    this.done = false,
  });
}
