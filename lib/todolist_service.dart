import 'dart:convert';
import 'package:flutter/material.dart';
import 'main.dart';

class Todo {
  Todo({
    required this.content,
  });

  UniqueKey id = UniqueKey();
  String content;

  Map toJson() {
    return {'content': content};
  }

  factory Todo.fromJson(json) {
    return Todo(content: json['content']);
  }
}

class TodoService extends ChangeNotifier {
  List<Todo> todoList = [
    Todo(content: '할일 1'),
    Todo(content: '할일 2'),
  ];
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
    print(todoList.length);
    notifyListeners();
  }
}
