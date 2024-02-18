import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_todo/models/listmodel.dart';

const int itemMaxLength = 64;

class ListItemCard extends StatefulWidget {
  final int index;
  
  const ListItemCard({required this.index, super.key});


  @override
  State<ListItemCard> createState() => _ListItemCardState();
}

class _ListItemCardState extends State<ListItemCard> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = Provider.of<TodoListModel>(context).items[widget.index].contents;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key("Card ${widget.index}"),
      onDismissed: (direction) => Provider.of<TodoListModel>(context, listen: false).removeEntryAt(widget.index),
      background: Container(
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
        ),
        padding: const EdgeInsets.only(left: 20.0),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.delete),
          ],
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: colorScheme.tertiaryContainer,
        ),
        padding: const EdgeInsets.only(right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: colorScheme.onTertiaryContainer,),
          ],
        ),
      ),
/*       secondaryBackground: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              // shape: BoxShape.values(),
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.tertiaryContainer
            ),
            child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onTertiaryContainer,),
          ),
          const Padding(padding: EdgeInsets.only(right: 20)),
        ],
      ), */
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        elevation: 0,
        color: colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Checkbox(
                value: Provider.of<TodoListModel>(context).items[widget.index].completed,
                onChanged: (value) => Provider.of<TodoListModel>(context, listen: false).updateChecked(widget.index, value!),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
              Expanded(
                child: TextField(
                  onChanged: (newtext) => Provider.of<TodoListModel>(context, listen: false).updateContents(widget.index, newtext),
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  decoration: null,
                  maxLength: itemMaxLength,
                  controller: controller,
                  style: Provider.of<TodoListModel>(context, listen: false).items[widget.index].completed 
                    ? const TextStyle(decoration: TextDecoration.lineThrough) 
                    : null,
                ),
              ),
              // IconButton(
              //   onPressed: () => Provider.of<TodoListModel>(context, listen: false).removeEntryAt(widget.index),
              //   icon: const Icon(Icons.delete),
              // ),
              // const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
              const Icon(Icons.drag_handle_rounded),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
