import "package:chess/widgets/piece.dart";
import "package:flutter/material.dart";

class Square extends StatelessWidget {
  final bool isWhiteVar;
  final ChessPiece? piece;
  const Square({super.key, required this.isWhiteVar, this.piece});

  @override
  Widget build(BuildContext context) {
    //TODO: make thses colors more premium
    return Container(
      color: isWhiteVar
          ? const Color.fromRGBO(235, 236, 208, 1)
          : const Color.fromRGBO(115, 149, 82, 1),
      child: piece != null ? Image.asset(piece!.imagePath) : null,
    );
  }
}
