import 'package:flutter/material.dart';

class LoadingItemsDisplay extends StatelessWidget {
  const LoadingItemsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Loading..."),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
          CircularProgressIndicator(
            semanticsLabel: "Loading List items.",
          ),
        ],
      ),
    );
  }
}
