import 'package:chess/helper/helper_methods.dart';
import 'package:chess/shared/theme.dart';
import 'package:chess/widgets/dead_piece.dart';
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

  // a list of white pieces that have been killed by the black pieces
  List<ChessPiece> capturedWhitePieces = [];

  // a list of black pieces that have been killed by the white pieces
  List<ChessPiece> capturedBlackPieces = [];

  // this is a bool to indicate whose turn
  bool isWhiteTurn = true;

  // initial position of king to see if the king is in check
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

  // this function is called when a square is tapped
  void pieceSelected(int row, int col) {
    setState(() {
      // no piece is selected
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPiece = board[row][col];
          selectedRow = row;
          selectedCol = col;
        }
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

    if (selectedPiece == null) return candidateMoves;

    int direction = selectedPiece.isWhite ? -1 : 1;

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

  //to move the pieces
  void movePiece(int newRow, int newCol) {
    // if the new spot has an opponent piece
    if (board[newRow][newCol] != null) {
      var capturedPiece = board[newRow][newCol]!;
      //adding to their places
      if (capturedPiece.isWhite) {
        capturedWhitePieces.add(capturedPiece);
      } else {
        capturedBlackPieces.add(capturedPiece);
      }
    }

    // move and clear the previous position
    board[newRow][newCol] = board[selectedRow][selectedCol];
    board[selectedRow][selectedCol] = null;

    // this sees if the king is in check
    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    // clear the selection
    setState(() {
      selectedPiece = null;
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
    });

    // change the turn
    isWhiteTurn = !isWhiteTurn;
  }

  bool isKingInCheck(bool isWhiteKing) {
    // Get the position of the king
    List<int> kingPosition = isWhiteKing
        ? whiteKingPosition
        : blackKingPosition;

    // Check if any opponent piece can attack the king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        // Ensure we don't check our own pieces
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }

        // this Calculate valid moves for the current piece
        List<List<int>> pieceValidMoves = calculateRawValidMoves(
          i,
          j,
          board[i][j],
        );

        // Check if the king's position is in the valid moves of any piece
        if (pieceValidMoves.any(
          (move) => move[0] == kingPosition[0] && move[1] == kingPosition[1],
        )) {
          return true; // king check vayo
        }
      }
    }
    return false; // No check found
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // here are the white pieces taken
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemCount: capturedWhitePieces.length,
              itemBuilder: (context, index) => DeadPiece(
                imagePath: capturedWhitePieces[index].imagePath,
                isWhite: true,
              ),
            ),
          ),

          // game status to show check or not and the winner and all
          Text(
            checkStatus ? "CHECK CHHA!" : "",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: MyColors.checkColor,
            ),

            //TODO: for winner announcement
          ),

          Expanded(
            flex: 5,
            child: GridView.builder(
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
                  isCanChapture:
                      isValidMove &&
                      board[row][col] != null &&
                      board[row][col]!.isWhite != selectedPiece?.isWhite,
                  onTap: () => pieceSelected(row, col),
                );
              },
            ),
          ),

          // and here are the black pieces taken
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemCount: capturedBlackPieces.length,
              itemBuilder: (context, index) => DeadPiece(
                imagePath: capturedBlackPieces[index].imagePath,
                isWhite: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
