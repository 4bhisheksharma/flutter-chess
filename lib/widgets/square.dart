import "package:flutter/material.dart";

class Square extends StatelessWidget {
  final bool isWhiteVar;
  const Square({super.key, required this.isWhiteVar});

  @override
  Widget build(BuildContext context) {
    //TODO: make thses colors more premium
    return Container(color: isWhiteVar ? Colors.white : Colors.black);
  }
}
