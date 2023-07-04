import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studdyplanner/todo_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

void main() async {
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
        List<Todo> todoList = todoService.todoList;

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
              ),
              IconButton(
                onPressed: () {
                  todoService.createTodo(content: '');
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: TodoDeailPage(
                          index: todoService.todoList.length - 1,
                        ),
                      );
                    },
                  );
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
          body: todoList.isEmpty
              ? Center(child: Text("메모를 작성해 주세요"))
              : Column(
                  children: [
                    TableCalendar(
                      firstDay: DateTime.utc(2021, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: DateTime.now(),
                      calendarFormat: CalendarFormat.week,
                      onDaySelected:
                          (DateTime selectedDay, DateTime focusedDay) {
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
                          Todo todo = todoList[index];
                          return isDeleteMode
                              ? TodoListDeleteCell(
                                  todo: todo,
                                  index: index,
                                )
                              : TodoListCell(
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
                            todoService.deleteTodo();
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

class TodoListCell extends StatelessWidget {
  const TodoListCell({required this.index, required this.todo});
  final Todo todo;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todo.content,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: TodoDeailPage(
                index: index,
              ),
            );
          },
        );
      },
    );
  }
}

class TodoListDeleteCell extends StatefulWidget {
  const TodoListDeleteCell({
    super.key,
    required this.todo,
    required this.index,
  });
  final Todo todo;
  final int index;

  @override
  State<TodoListDeleteCell> createState() => _TodoListDeleteCellState();
}

class _TodoListDeleteCellState extends State<TodoListDeleteCell> {
  bool? isSeleted = false;
  @override
  Widget build(BuildContext context) {
    TodoService todoService = context.read<TodoService>();

    return CheckboxListTile(
      title: Text(
        widget.todo.content,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      controlAffinity: ListTileControlAffinity.leading,
      value: isSeleted,
      onChanged: (bool? value) {
        setState(() {
          isSeleted = value;
          if (value != null && value) {
            todoService.deleteList.add(widget.todo.id);
          } else if (value != null && !value) {
            todoService.deleteList.remove(widget.todo.id);
          }
        });
      },
    );
  }
}

class TodoDeailPage extends StatelessWidget {
  const TodoDeailPage({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    TodoService todoService = context.read<TodoService>();
    Todo todo = todoService.todoList[index];
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width * 0.6,
      height: screenSize.height * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
              child: Text(
                "나의 할일",
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: screenSize.height * 0.15,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextField(
                    onChanged: (value) {
                      todoService.updateTodo(index: index, content: value);
                    },
                    controller: TextEditingController(text: todo.content),
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                    ),
                    autofocus: true,
                    textAlign: TextAlign.center,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "취소",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "확인",
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
