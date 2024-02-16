import 'package:flutter/material.dart';

class ListItemCard extends StatefulWidget {
  const ListItemCard({super.key});

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
          const Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0), //TODO - change
              child: TextField(
                expands: true,
                maxLines: null,
                minLines: null,
                decoration: null,
              ),
            ),
          ),
          const Icon(Icons.drag_handle_rounded),
        ],
      ),
    );
  }
}
