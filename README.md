# Flutter Chess Game

## Description

A simple 2-player chess game built with Flutter. This app implements standard chess rules including piece movements, check, and checkmate detection.

## Features

- **Standard Chess Rules**: Complete implementation of chess piece movements (pawn, rook, knight, bishop, queen, king)
- **Turn-Based Gameplay**: Alternating turns between white and black players (white starts)
- **Move Validation**: Highlights valid moves and prevents illegal moves
- **Capture Mechanics**: Pieces can capture opponents, with captured pieces displayed
- **Check Detection**: Automatically detects when a king is in check
- **Checkmate Detection**: Ends the game when checkmate occurs
- **Game Reset**: Option to start a new game after checkmate
- **Responsive UI**: Clean interface with alternating board colors and piece images

## Installation

1. Ensure you have Flutter installed on your system.

2. Clone this repository:
   ```bash
   git clone https://github.com/4bhisheksharma/flutter-chess.git
   cd chess
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

## Usage

1. Run the app on an emulator or connected device:
   ```bash
   flutter run
   ```

2. **Gameplay Instructions**:
   - Tap on a piece to select it (only your color's pieces when it's your turn)
   - Valid moves are highlighted with green circles
   - Capturable pieces are highlighted in red
   - Tap on a highlighted square to move the piece
   - Captured pieces appear at the top (white) or bottom (black) of the screen
   - The game automatically detects check and displays "CHECK CHHA Hai!"
   - When checkmate occurs, a dialog appears with option to reset
   - Click "Lu Feri Khelum!" to start a new game

## Project Structure

```
lib/
├── main.dart              # Application entry point and MaterialApp setup
├── game_board.dart        # Main game logic, board state, and UI layout
├── widgets/
│   ├── piece.dart         # ChessPiece model class and ChessPieceType enum
│   ├── square.dart        # Individual board square widget with tap handling
│   └── dead_piece.dart    # Widget for displaying captured pieces
├── helper/
│   └── helper_methods.dart # Utility functions for board calculations
└── shared/
    └── theme.dart         # Color constants and theming

assets/
└── images/               # PNG images for all chess pieces (white/black variants)
    ├── wp.png, wb.png, wn.png, wr.png, wq.png, wk.png
    └── bp.png, bb.png, bn.png, br.png, bq.png, bk.png
```

## Dependencies

- **Flutter SDK**: ^3.8.1
- **cupertino_icons**: ^1.0.8

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. Areas for improvement include:
- Enhanced UI/animations
- Features like castle, promotions, and en passant move
- More extra features needed for chess game...

## License

This project is open source, anyone can use it.
