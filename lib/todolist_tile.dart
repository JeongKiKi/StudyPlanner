import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studdyplanner/todo_detail_dialog.dart';
import 'package:studdyplanner/todo_service.dart';

// 기본 투두리스트 타일
class TodoListTile extends StatelessWidget {
  const TodoListTile({required this.index, required this.todo});
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
              content: TodoDeailDialog(
                index: index,
              ),
            );
          },
        );
      },
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
