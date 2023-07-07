import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studdyplanner/todo_detail_dialog.dart';
import 'package:studdyplanner/todo_service.dart';

// 기본 투두리스트 타일
class TodoListTile extends StatefulWidget {
  const TodoListTile({required this.index, required this.todo});
  final int index;
  final Todo todo;

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    TodoService todoService = context.read<TodoService>();

    return Container(
      color: widget.todo.done ? Colors.grey[200] : null,
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
              todoService.updateDoneTodo(id: widget.todo.id);
            });
          },
          child: Icon(
            widget.todo.done
                ? CupertinoIcons.nosign
                : CupertinoIcons.check_mark,
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: TodoDeailDialog(
                  todo: widget.todo,
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
  // bool? isSeleted = false;
  @override
  Widget build(BuildContext context) {
    TodoService todoService = context.read<TodoService>();
    bool? isSelected = todoService.deleteCheckList.contains(widget.todo.id);

    return CheckboxListTile(
      title: Text(
        widget.todo.content,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      controlAffinity: ListTileControlAffinity.leading,
      value: isSelected,
      onChanged: (bool? value) {
        setState(() {
          isSelected = value;
          if (value != null && value) {
            todoService.deleteCheckList.add(widget.todo.id);
          } else if (value != null && !value) {
            todoService.deleteCheckList.remove(widget.todo.id);
          }
        });
      },
    );
  }
}
