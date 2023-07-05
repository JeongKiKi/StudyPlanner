import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studdyplanner/todo_service.dart';

class TodoDeailDialog extends StatelessWidget {
  const TodoDeailDialog({required this.index});

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
                    todoService.removeTodo(todo);
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
                    if (todo.content.isEmpty) {
                      todoService.removeTodo(todo);
                    }
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
