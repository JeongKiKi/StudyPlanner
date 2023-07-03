import 'dart:convert';
import 'package:flutter/material.dart';
import 'main.dart';

// Memo 데이터의 형식을 정해줍니다. 추후 isPinned, updatedAt 등의 정보도 저장할 수 있습니다.
class Todo {
  Todo({
    required this.content,
    this.done = false,
    this.updatedAt,
  });

  String content;
  bool done;
  DateTime? updatedAt;

  Map toJson() {
    return {
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

// Memo 데이터는 모두 여기서 관리
class TodoService extends ChangeNotifier {
  TodoService() {
    loadTodoList();
  }

  List<Todo> todoList = [
    Todo(content: '새 메모 1'), // 더미(dummy) 데이터
    Todo(content: '새 메모 2'), // 더미(dummy) 데이터
  ];

  loadTodoList() {
    String? jsonString = prefs.getString('todoList');
    // '[{"content": "1"}, {"content": "2"}]'

    if (jsonString == null) return; // null 이면 로드하지 않음

    List todoJsonList = jsonDecode(jsonString);
    // [{"content": "1"}, {"content": "2"}]

    todoList = todoJsonList.map((json) => Todo.fromJson(json)).toList();
  }
}
