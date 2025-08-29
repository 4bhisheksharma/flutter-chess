import "package:flutter/material.dart";

class Square extends StatelessWidget {
  final bool isWhite;
  const Square({super.key, required this.isWhite});

  @override
  Widget build(BuildContext context) {
    //TODO: make thses colors more premium
    return Container(color: isWhite ? Colors.white : Colors.black);
  }
}
