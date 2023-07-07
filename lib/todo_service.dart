import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'main.dart';

class Todo {
  Todo({
    required this.content,
    this.done = false,
    this.updatedAt,
    required this.createAt,
  });

  String id = UniqueKey().toString();
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
        createAt: DateTime.parse(json['createAt']));
  }
}

class TodoService extends ChangeNotifier {
  TodoService() {
    loadMemoList();
  }
  List<Todo> todoList = [];

  // 달력클릭시 보이게 될 날짜별로 투두리스트를 모아놓은 해시맵 변수
  LinkedHashMap<DateTime, List<Todo>> events =
      LinkedHashMap<DateTime, List<Todo>>(
    equals: isSameDay,
  );

  // 삭제 아이콘 클릭시 나오는 체크박스에 체크될 경우 담기게 되는 삭제리스트
  List<String> deleteCheckList = [];

  createTodo({required String content, required DateTime createTime}) {
    Todo todo = Todo(content: content, createAt: createTime);
    todoList.add(todo);
    addEvent(todo);
    notifyListeners();
    saveMemoList();
  }

  updateTodo({required int index, required String content}) {
    Todo todo = todoList[index];
    todo.content = content;
    notifyListeners();
    saveMemoList();
  }

  // deleteCheckList에 담긴 투두리스트들을 삭제하는 메서드
  deleteTodoList() {
    List<Todo> deleteTodoList =
        todoList.where((todo) => deleteCheckList.contains(todo.id)).toList();
    List<DateTime> deleteEventList = deleteTodoList.map(
      (todo) {
        return todo.createAt;
      },
    ).toList();
    events.forEach((key, value) {
      if (deleteEventList.contains(key)) {
        value.removeWhere((todo) => deleteCheckList.contains(todo.id));
      }
    });
    todoList.removeWhere((todo) => deleteCheckList.contains(todo.id));
    notifyListeners();
    saveMemoList();
  }

  // 하나의 투두리스트를 삭제하는 메서드
  removeTodo(Todo todo) {
    events.forEach((key, value) {
      if (key == todo.createAt) {
        value.removeWhere((element) => element.id == todo.id);
      }
    });
    todoList.removeLast();
    notifyListeners();
    saveMemoList();
  }

  List<Todo> getTodoList(DateTime day) {
    return events[day] ?? [];
  }

  saveMemoList() {
    List todoJsonList = todoList.map((todo) => todo.toJson()).toList();
    String jsonString = jsonEncode(todoJsonList);
    prefs.setString('TodoList', jsonString);
  }

  loadMemoList() {
    String? jsonString = prefs.getString('TodoList');
    if (jsonString == null) return; // null 이면 로드하지 않음
    List todoJsonList = jsonDecode(jsonString);

    todoList = todoJsonList.map((json) => Todo.fromJson(json)).toList();
    for (var todo in todoList) {
      addEvent(todo);
    }
  }

  addEvent(Todo todo) {
    if (events[todo.createAt] != null) {
      events[todo.createAt]!.add(todo);
    } else {
      events[todo.createAt] = [todo];
    }
  }
}
