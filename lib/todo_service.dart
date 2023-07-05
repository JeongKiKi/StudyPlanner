import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Todo {
  Todo({
    required this.content,
    this.done = false,
    this.updatedAt,
    required this.createAt,
  });

  UniqueKey id = UniqueKey();
  String content;
  bool done;
  DateTime? updatedAt;
  final DateTime createAt;

  Map toJson() {
    return {
      'id': id,
      'content': content,
      'isDone': done,
      'updatedAt': updatedAt?.toIso8601String(),
      'createAt': createAt.toIso8601String(),
    };
  }

  factory Todo.fromJson(json) {
    return Todo(
        content: json['content'],
        done: json['isDone'] ?? false,
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
        createAt: json['createAt']);
  }
}

class TodoService extends ChangeNotifier {
  List<Todo> todoList = [];
  final events = LinkedHashMap<DateTime, List<Todo>>(
    equals: isSameDay,
  );
  List<UniqueKey> deleteList = [];

  createTodo({required String content, required DateTime createTime}) {
    Todo todo = Todo(content: content, createAt: createTime);
    todoList.add(todo);
    if (events[createTime] != null) {
      events[createTime]!.add(todo);
    } else {
      events[createTime] = [todo];
    }
    notifyListeners();
  }

  updateTodo({required int index, required String content}) {
    Todo todo = todoList[index];
    todo.content = content;
    notifyListeners();
  }

  deleteTodo() {
    List<Todo> deleteTodoList =
        todoList.where((todo) => deleteList.contains(todo.id)).toList();
    List<DateTime> deleteEventList = deleteTodoList.map(
      (todo) {
        return todo.createAt;
      },
    ).toList();
    events.forEach((key, value) {
      if (deleteEventList.contains(key)) {
        value.removeWhere((todo) => deleteList.contains(todo.id));
      }
    });
    todoList.removeWhere((todo) => deleteList.contains(todo.id));
    notifyListeners();
  }

  removeTodo(Todo todo) {
    events.forEach((key, value) {
      if (key == todo.createAt) {
        value.removeWhere((element) => element.id == todo.id);
      }
    });
    todoList.removeLast();
    notifyListeners();
  }

  List<Todo> getEvents(DateTime day) {
    return events[day] ?? [];
  }
}
