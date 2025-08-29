import "package:chess/shared/theme.dart";
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
      color: isWhiteVar ? MyColors.primaryColor : MyColors.secondaryColor,
      child: piece != null
          ? Image.asset(
              piece!.imagePath,
              // color: piece!.isWhite ? Colors.white : Colors.black,
            )
          : null,
    );
  }
}
