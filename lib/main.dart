import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studdyplanner/todo_detail_dialog.dart';
import 'package:studdyplanner/todo_service.dart';
import 'package:studdyplanner/todolist_tile.dart';
import 'package:studdyplanner/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  bool isDeleteMode = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoService>(
      builder: (context, todoService, child) {
        // 달력에 선택된 날들의 투두리스트들을 모아놓은 변수
        List<Todo> selectDayTodoList =
            todoService.getTodoList(createTimeForEvent(selectedDay));
        return Scaffold(
          appBar: AppBar(
            title: Text("mymemo"),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isDeleteMode = !isDeleteMode;
                  });
                },
                icon: Icon(Icons.delete),
                color: isDeleteMode ? Colors.red : Colors.black,
              ),
              IconButton(
                onPressed: () {
                  todoService.createTodo(
                    content: '',
                    createTime: createTimeForEvent(selectedDay),
                  );
                  showDialog(
                    context: context,
                    barrierDismissible: false, // 배경 터치 시 닫히지 않도록 설정
                    builder: (context) {
                      return AlertDialog(
                        content: TodoDeailDialog(
                          todo: todoService.todoList.last,
                          pressAddBtn: true,
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          body: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2021, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: focusedDay,
                calendarFormat: CalendarFormat.week,
                eventLoader: todoService.getTodoList,
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  setState(() {
                    this.selectedDay = selectedDay;
                    this.focusedDay = focusedDay;
                  });
                },
                selectedDayPredicate: (DateTime day) {
                  return isSameDay(selectedDay, day);
                },
                onFormatChanged: (format) {
                  setState(() {
                    DateTime today = createTimeForEvent(DateTime.now());
                    focusedDay = today;
                    selectedDay = today;
                  });
                },
              ),
              selectDayTodoList.isEmpty
                  ? Expanded(child: Center(child: Text("할일을 작성해 주세요")))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: selectDayTodoList.length,
                        itemBuilder: (context, index) {
                          Todo todo = selectDayTodoList[index];
                          return isDeleteMode
                              ? TodoListDeleteTile(
                                  todo: todo,
                                  index: index,
                                )
                              : TodoListTile(
                                  index: index,
                                  todo: todo,
                                );
                        },
                      ),
                    ),
              Visibility(
                visible: isDeleteMode,
                child: Container(
                  color: Colors.red,
                  height: 60,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      todoService.deleteTodoList();
                    },
                    child: Text(
                      "삭제하기",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
