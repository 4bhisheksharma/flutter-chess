import 'package:chess/helper/helper_methods.dart';
import 'package:chess/widgets/piece.dart';
import 'package:chess/widgets/square.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //here is a 2D list representing the chess board
  // with each position possibly containing a piece
  late List<List<ChessPiece?>> board;

  ChessPiece? selectedPiece;

  int selectedRow = -1;
  int selectedCol = -1;

  // this is a list of valid moves currently selected piece
  // so each move is represented as a list of [row, col] pairs
  List<List<int>> validMoves = [];

  void pieceSelected(int row, int col) {
    setState(() {
      // no piece is selected
      if (selectedPiece == null && board[row][col] != null) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
      // there is the piece which is already selected but the player can select another piece
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece!.isWhite) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
      // if there is the place which is selected
      //and the player tap on a square which is a valid move then, move there
      else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
        return; // to avoid clearing the selection below
      }

      // here is the logic of determining valid moves for the selected piece
      validMoves = calculateRawValidMoves(
        selectedRow,
        selectedCol,
        selectedPiece,
      ); // it is raw since some moves may be blocked or illigal
    });
  }

  // calculate raw valid move
  List<List<int>> calculateRawValidMoves(
    int row,
    int col,
    ChessPiece? selectedPiece,
  ) {
    List<List<int>> candidateMoves = [];
    int direction = selectedPiece!.isWhite ? -1 : 1;

    switch (selectedPiece.type) {
      case ChessPieceType.pawn:
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
          // this Check for initial double move
          if ((selectedPiece.isWhite && row == 6) ||
              (!selectedPiece.isWhite && row == 1)) {
            if (isInBoard(row + 2 * direction, col) &&
                board[row + 2 * direction][col] == null) {
              candidateMoves.add([row + 2 * direction, col]);
            }
          }
        }

      case ChessPieceType.rook:

        //horizontal and vertical directions
        var directions = [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1],
        ];

        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }

            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != selectedPiece.isWhite) {
                // can capture
                candidateMoves.add([newRow, newCol]);
              }
              break; // block the move
            }

            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        var knightMoves = [
          [2, 1],
          [2, -1],
          [-2, 1],
          [-2, -1],
          [1, 2],
          [1, -2],
          [-1, 2],
          [-1, -2],
        ];
        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != selectedPiece.isWhite) {
              // can capture
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        //diagonal directions hunchha yesko
        var directions = [
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1],
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != selectedPiece.isWhite) {
                // can capture
                candidateMoves.add([newRow, newCol]);
              }
              break; //block the move
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        // horizontal, vertical and diagonal directions
        var directions = [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1],
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1],
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != selectedPiece.isWhite) {
                // can capture
                candidateMoves.add([newRow, newCol]);
              }
              break; //block the move
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        var kingMoves = [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1],
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1],
        ];
        for (var move in kingMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != selectedPiece.isWhite) {
              // can capture
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
    }

    // Filter out invalid moves
    candidateMoves = candidateMoves.where((move) {
      int newRow = move[0];
      int newCol = move[1];
      return isInBoard(newRow, newCol);
    }).toList();

    return candidateMoves;
  }

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard = List.generate(
      8,
      (index) => List.generate(8, (index) => null),
    );

    // this is only for testing ---
    // newBoard[3][3] = ChessPiece(
    //   type: ChessPieceType.knight,
    //   isWhite: true,
    //   imagePath: 'assets/images/wn.png',
    // );

    // Place pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: false,
        imagePath: 'assets/images/bp.png',
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        isWhite: true,
        imagePath: 'assets/images/wp.png',
      );
    }
    // Place other pieces
    newBoard[0][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'assets/images/br.png',
    );
    newBoard[0][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'assets/images/bn.png',
    );
    newBoard[0][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'assets/images/bb.png',
    );
    newBoard[0][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: false,
      imagePath: 'assets/images/bq.png',
    );
    newBoard[0][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: false,
      imagePath: 'assets/images/bk.png',
    );
    newBoard[0][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: false,
      imagePath: 'assets/images/bb.png',
    );
    newBoard[0][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: false,
      imagePath: 'assets/images/bn.png',
    );
    newBoard[0][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: false,
      imagePath: 'assets/images/br.png',
    );
    newBoard[7][0] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'assets/images/wr.png',
    );
    newBoard[7][1] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'assets/images/wn.png',
    );
    newBoard[7][2] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'assets/images/wb.png',
    );
    newBoard[7][3] = ChessPiece(
      type: ChessPieceType.queen,
      isWhite: true,
      imagePath: 'assets/images/wq.png',
    );
    newBoard[7][4] = ChessPiece(
      type: ChessPieceType.king,
      isWhite: true,
      imagePath: 'assets/images/wk.png',
    );
    newBoard[7][5] = ChessPiece(
      type: ChessPieceType.bishop,
      isWhite: true,
      imagePath: 'assets/images/wb.png',
    );
    newBoard[7][6] = ChessPiece(
      type: ChessPieceType.knight,
      isWhite: true,
      imagePath: 'assets/images/wn.png',
    );
    newBoard[7][7] = ChessPiece(
      type: ChessPieceType.rook,
      isWhite: true,
      imagePath: 'assets/images/wr.png',
    );
    setState(() {
      board = newBoard;
    });
  }

  //to move the pieces
  void movePiece(int newRow, int newCol) {
    // move and clear the previous position
    board[newRow][newCol] = board[selectedRow][selectedCol];
    board[selectedRow][selectedCol] = null;

    // clear the selection
    setState(() {
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 8 * 8,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: (context, index) {
          // this is to get the row and column of this square
          int row = index ~/ 8;
          int col = index % 8;

          // this checks the square is selected or not
          bool isSelected = (row == selectedRow && col == selectedCol);

          // check the square is valid move or not
          bool isValidMove = false;
          for (var position in validMoves) {
            if (position[0] == row && position[1] == col) {
              isValidMove = true;
              break;
            }
          }

          return Square(
            isWhiteVar: isWhiteSquare(index),
            piece: board[row][col],
            isSelected: isSelected,
            isValidMove: isValidMove,
            onTap: () => pieceSelected(row, col),
          );
        },
      ),
    );
  }
}
