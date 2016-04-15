import 'package:ng_checkers/app/game/checkers_service.dart';

class CheckersBoard {
  int BOARD_SIZE = 8;

  //8x8 checkers board

  List<List<BoardSquare>> board;

  CheckersService checkersService;

  CheckersBoard(this.checkersService,
      [this.BOARD_SIZE = 8]) //default to 8x8 board
  {
    board = _createBoard();
  }

  bool movePiece(int originRow, int originCol, int targetRow, int targetCol)
  {
    if(!onBoard(originRow, originCol) || !onBoard(targetRow, targetCol))
    {
      return false;
    }

    BoardSquare originSquare = board[originRow][originCol];
    BoardSquare targetSquare = board[targetRow][targetCol];

    if(!targetSquare.occupied() && canMove(originSquare, targetSquare,
        originRow, originCol, targetRow, targetCol))
    {
      targetSquare.piece = originSquare.piece;
      originSquare.piece = null;

      checkKing(targetSquare, targetRow);

      return true;
    }

    return false;
  }

  checkKing(BoardSquare square, int row)
  {
    Player player = square.piece.owner;

    //King the piece if it reaches the proper end of the board
     if(!square.piece.king &&
        ((player.color == "blue" && row == 0) ||
        (player.color == "red" && row == 7)))
     {
       square.piece.king = true;
     }
  }

  bool canMove(BoardSquare originSquare, BoardSquare targetSquare,
      int originRow, int originCol, int targetRow, int targetCol)
  {
    bool result = false;
    bool madeJump = false;

    Player player = originSquare.piece.owner;

    bool king = originSquare.piece.king;

    int direction = player.color == "blue" ? 1 : -1;

    int deltaR = targetRow - originRow;
    int deltaC = targetCol - originCol;

    int distanceR = deltaR < 0 ? -deltaR : deltaR;
    int distanceC = deltaC < 0 ? -deltaC : deltaC;

    BoardSquare jumped;

    if(distanceC == 2)
    {
      //do jump first, then move
      int jumpedR = targetRow - (deltaR/2).toInt();
      int jumpedC = targetCol - (deltaC/2).toInt();
      jumped = board[jumpedR][jumpedC];

      if(jumped == null || (jumped.occupied() && jumped.piece.owner == player))
      {
        return false; //cannot move more than 1 tile without jumping
      }
      else if(distanceC == distanceR) //make sure we are moving diagonally
      {
        jumped.piece.owner.pieces--; //decrement player piece pool for win condition
        jumped.piece = null; //remove piece from game
        madeJump = true;
      }
    }

    //first check if within 2 units of row and col, then make sure diagonal move
    result = (distanceC >= 1 && distanceC <= 2) &&
        (distanceR >= 1 && distanceR <= 2) && (distanceC == distanceR);

    //Do additional check to make sure move is in right direction for non king piece
    if(!originSquare.piece.king && result)
    {
      //for blue player, make sure you are moving 'up'
      result = player.color == "blue" ? deltaR < 0 : deltaR > 0;
    }

    //do move

    //result = inRange(player1, king, originRow, originCol, targetRow, targetCol);

//    if(!result)
//    {
//      BoardSquare jumpTarget = attemptJump(player1, king, originRow, originCol, targetRow, targetCol);
//      result = jumpTarget != null;
//    }

    //TODO: remove any pieces, check for an additional move

    //TODO: check for king-ing

    //TODO: check for win condition

    return result;
  }

  bool onBoard(int r, int c)
  {
    //Check if within valid board bounds
    return r >= 0 && r < BOARD_SIZE && c >= 0 && c < BOARD_SIZE;
  }

  List<List<BoardSquare>> _createBoard() {
    List boardRows = new List<List<BoardSquare>>();

    for (int r = 0; r < BOARD_SIZE; r++) {
      List boardCols = new List<BoardSquare>();
      for (int c = 0; c < BOARD_SIZE; c++) {
        BoardPiece piece = null;

        if (r % 2 == c % 2) {
          boardCols.add(new BoardSquare("white"));
        }
        else {
          boardCols.add(new BoardSquare("grey", piece));
        }
      }

      boardRows.add(boardCols);
    }

    return boardRows;
  }

  addPieces() {
    for (int r = 0; r < BOARD_SIZE; r++) {
      for (int c = 0; c < BOARD_SIZE; c++) {
        if (r % 2 != c % 2) {
          if (r < 3) {
            board[r][c].piece = new BoardPiece(checkersService.player1);
            checkersService.player1.pieces++;
          }
          else if (r > 4) {
            board[r][c].piece = new BoardPiece(checkersService.player2);
            checkersService.player2.pieces++;
          }
        }
      }
    }
  }
}

class BoardSquare
{
  BoardPiece piece;
  String color;
  bool selected;

  BoardSquare(this.color, [this.piece = null])
  {
    selected = false;
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

  String get color => owner != null ? owner.color : "";

  BoardPiece(this.owner)
  {
    king = false;
  }
}

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

  bool makeMove(int originRow, int originCol, int targetRow, int targetCol)
  {
    return board.movePiece(originRow, originCol, targetRow, targetCol);
  }
}