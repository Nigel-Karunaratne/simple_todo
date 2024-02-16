import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo/models/listmodel.dart';

class ListItemCard extends StatefulWidget {
  final int index;
  
  const ListItemCard({required this.index, super.key});


  @override
  State<ListItemCard> createState() => _ListItemCardState();
}

class _ListItemCardState extends State<ListItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      // child: CheckboxListTile(
      //   onChanged: (value) {},
      //   value: false,
      //   controlAffinity: ListTileControlAffinity.leading,
      //   title: TextField(
      //     controller: TextEditingController(text: "String!"),
      //   ),
      // ),
      child: Row(
        children: [
          Checkbox(
            value: false,
            onChanged: (value){}
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0), //TODO - change
              child: TextField(
                expands: true,
                maxLines: null,
                minLines: null,
                decoration: null,
                controller: TextEditingController(text: Provider.of<TodoListModel>(context, listen: false).items[widget.index].contents),
              ),
            ),
          ),
          const Icon(Icons.drag_handle_rounded),
        ],
      ),
    );
  }
}
