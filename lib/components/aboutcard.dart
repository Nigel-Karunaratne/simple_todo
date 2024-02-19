import 'package:flutter/material.dart';

class AboutAppView extends StatelessWidget {
  const AboutAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text("- A simple TODO list app -", style: TextStyle(fontStyle: FontStyle.italic),),
          SizedBox(height: 20),
          Text("List entries can be added by pressing the big \"plus\" button in the bottom-right corner."),
          SizedBox(height: 10),
          Text("Each entry can be checked off by pressing the check box on its left."),
          SizedBox(height: 10),
          Text("To change the text of a list entry, simply tap on it."),
          SizedBox(height: 10),
          Text("Entries can be reordered by holding down the two vertical bars on the right and dragging up or down."),
          SizedBox(height: 10),
          Text("To delete an entry, swipe left or right on it."),
          SizedBox(height: 10),
          Text("To delete all checked entries or delete every entry, press the three dots in the upper right corner and select an option."),
          SizedBox(height: 20),
          Text("** Made by Nigel Karunaratne **", style: TextStyle(fontStyle: FontStyle.italic),),
        ],
      ),
    );
  }
}