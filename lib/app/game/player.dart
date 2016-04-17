import 'package:ng_checkers/app/game/checkers_board.dart';

class Player
{
  String name;
  String color;
  CheckersBoard board;
  int pieces;

  Player(this.name, this.color, this.board)
  {
    pieces = 0;
  }

  bool makeMove(Move move)
  {
    return board.movePiece(move);
  }
}