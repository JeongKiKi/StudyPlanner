import 'package:flutter/material.dart';

class Todo {
  Todo({
    required this.content,
    this.done = false,
    this.updatedAt,
  });

  UniqueKey id = UniqueKey();
  String content;
  bool done;
  DateTime? updatedAt;

  Map toJson() {
    return {
      'id': id,
      'content': content,
      'isDone': done,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Todo.fromJson(json) {
    return Todo(
      content: json['content'],
      done: json['isDone'] ?? false,
      updatedAt:
          json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
    );
  }
}

class TodoService extends ChangeNotifier {
  List<Todo> todoList = [];
  List<UniqueKey> deleteList = [];

  createTodo({required String content}) {
    Todo todo = Todo(content: content);
    todoList.add(todo);
    notifyListeners();
  }

  updateTodo({required int index, required String content}) {
    Todo todo = todoList[index];
    todo.content = content;
    notifyListeners();
  }

  deleteTodo() {
    todoList.removeWhere((todo) => deleteList.contains(todo.id));
    notifyListeners();
  }
}
