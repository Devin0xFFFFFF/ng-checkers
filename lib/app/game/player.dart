import 'package:ng_checkers/app/game/checkers_board.dart';

class Player
{
  String name;
  String color;
  CheckersBoard board;

  Player(this.name, this.color, this.board)
  {

  }

  bool makeMove(Move move)
  {
    return board.movePiece(move);
  }

  toString()
  {
    return color[0].toUpperCase() + color.substring(1);
  }
}