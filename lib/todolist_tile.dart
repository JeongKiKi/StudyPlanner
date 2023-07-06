import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studdyplanner/todo_detail_dialog.dart';
import 'package:studdyplanner/todo_service.dart';

// 기본 투두리스트 타일
class TodoListTile extends StatefulWidget {
  const TodoListTile({required this.index, required this.todo});
  final Todo todo;
  final int index;

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  bool isComplete = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: isComplete ? Colors.grey[200] : null,
      child: ListTile(
        title: Text(
          widget.todo.content,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        //완료 버튼
        trailing: GestureDetector(
          onTap: () {
            setState(() {
              isComplete = !isComplete;
            });
          },
          child: Icon(
            isComplete ? CupertinoIcons.nosign : CupertinoIcons.check_mark,
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: TodoDeailDialog(
                  index: widget.index,
                  pressAddBtn: false,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// 삭제 버튼 클릭시 나오는 타일
class TodoListDeleteTile extends StatefulWidget {
  const TodoListDeleteTile({
    super.key,
    required this.todo,
    required this.index,
  });
  final Todo todo;
  final int index;

  @override
  State<TodoListDeleteTile> createState() => _TodoListDeleteTileState();
}

class _TodoListDeleteTileState extends State<TodoListDeleteTile> {
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
