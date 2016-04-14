class CheckersBoard
{
  static int BOARD_SIZE = 8; //8x8 checkers board

  List<List<BoardSquare>> board;
  Player player1, player2;
  int turn;

  CheckersBoard(String player1Name, String player2Name)
  {
    player1 = new Player(player1Name, "red");
    player2 = new Player(player2Name, "blue");

    board = _createBoard();
  }

  List<List<BoardSquare>> _createBoard()
  {
    List boardRows = new List<List<BoardSquare>>();

    for(int r = 0; r < BOARD_SIZE; r++)
    {
      List boardCols = new List<BoardSquare>();
      for(int c = 0; c < BOARD_SIZE; c++)
      {
        BoardPiece piece = null;

        if(r % 2 == c % 2)
        {
          boardCols.add(new BoardSquare("white"));
        }
        else
        {
          //Add player pieces on darker squares
          if(r < 3)
          {
            piece = new BoardPiece(player1);
          }
          else if(r > 4)
          {
            piece = new BoardPiece(player2);
          }
          boardCols.add(new BoardSquare("grey", piece));
        }
      }

      boardRows.add(boardCols);
    }

    return boardRows;
  }
}

class BoardSquare
{
  BoardPiece piece;
  String color;

  BoardSquare(this.color, [this.piece = null])
  {

  }

  bool occupied()
  {
    return piece != null;
  }
}

class BoardPiece
{
  Player owner;
  bool king;

  String get color => owner.color;

  BoardPiece(this.owner)
  {
    king = false;
  }
}

class Player
{
  String name;
  String color;

  Player(this.name, this.color)
  {

  }
}