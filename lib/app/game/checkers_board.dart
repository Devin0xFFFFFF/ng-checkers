import 'package:ng_checkers/app/game/checkers_service.dart';
import 'package:ng_checkers/app/game/player.dart';

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

  BoardSquare at(Position pos)
  {
    return board[pos.row][pos.col];
  }

  bool movePiece(Move move)
  {
    if(!onBoard(move.origin.row, move.origin.col) || !onBoard(move.destination.row, move.destination.col))
    {
      return false;
    }

    BoardSquare originSquare = board[move.origin.row][move.origin.col];
    BoardSquare targetSquare = board[move.destination.row][move.destination.col];

    if(!targetSquare.occupied() && canMove(originSquare, targetSquare, move))
    {
      targetSquare.piece = originSquare.piece;
      originSquare.piece = null;

      checkKing(targetSquare, move.destination.row);

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

  bool canMove(BoardSquare originSquare, BoardSquare targetSquare, Move move)
  {
    bool result = false;
    bool madeJump = false;

    Player player = originSquare.piece.owner;

    bool king = originSquare.piece.king;

    int direction = player.color == "blue" ? 1 : -1;

    int deltaR = move.destination.row - move.origin.row;
    int deltaC = move.destination.col - move.origin.col;

    int distanceR = deltaR < 0 ? -deltaR : deltaR;
    int distanceC = deltaC < 0 ? -deltaC : deltaC;

    BoardSquare jumped;

    if(distanceC == 2)
    {
      //do jump first, then move
      int jumpedR = move.destination.row - (deltaR/2).toInt();
      int jumpedC = move.destination.col - (deltaC/2).toInt();
      jumped = board[jumpedR][jumpedC];

      if(jumped == null || (jumped.occupied() && jumped.piece.owner == player))
      {
        return false; //cannot move more than 1 tile without jumping
      }
      else if(distanceC == distanceR) //make sure we are moving diagonally
      {
        //jumped.piece.owner.pieces--; //decrement player piece pool for win condition
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

    return result;
  }

  bool onBoard(int r, int c)
  {
    //Check if within valid board bounds
    return r >= 0 && r < BOARD_SIZE && c >= 0 && c < BOARD_SIZE;
  }

  Moves getPossibleMoves(Player player)
  {
    Moves possibleMoves = new Moves();

    for(int r = 0; r < BOARD_SIZE; r++)
    {
      for(int c = 0; c < BOARD_SIZE; c++)
      {
        BoardSquare square = board[r][c];
        Position currentPosition = new Position(r, c);
        //If the current player owns the piece, check for moves
        if(square.occupied() && player == square.piece.owner)
        {
          //find all possible jumps and moves
          List<Position> jumpPositions = possibleJumpsFrom(new Position(r, c));
          List<Position> movePositions = possibleMovesFrom(new Position(r, c));

          List<Move> jumps = [];
          List<Move> moves = [];

          //append each as a new move from (r, c) to the target position
          jumpPositions.forEach((Position pos){
            jumps.add(new Move(currentPosition, pos));
          });

          movePositions.forEach((Position pos){
            moves.add(new Move(currentPosition, pos));
          });

          possibleMoves.addJumps(jumps);
          possibleMoves.addMoves(moves);
        }
      }
    }

    return possibleMoves;
  }

  List<Position> possibleMovesFrom(Position pos)
  {
    BoardSquare square = board[pos.row][pos.col];
    int direction = square.piece.owner.color == "blue" ? 1 : -1;

    List<Position> possiblePositions = [];

    if(square.piece.king)
    {
      _addMovePositionIfValid(possiblePositions, pos.row - 1, pos.col - 1);
      _addMovePositionIfValid(possiblePositions, pos.row - 1, pos.col + 1);
      _addMovePositionIfValid(possiblePositions, pos.row + 1, pos.col - 1);
      _addMovePositionIfValid(possiblePositions, pos.row + 1, pos.col + 1);
    }
    else
    {
      if(direction == 1)
      {
        _addMovePositionIfValid(possiblePositions, pos.row - 1, pos.col - 1);
        _addMovePositionIfValid(possiblePositions, pos.row - 1, pos.col + 1);
      }
      else
      {
        _addMovePositionIfValid(possiblePositions, pos.row + 1, pos.col - 1);
        _addMovePositionIfValid(possiblePositions, pos.row + 1, pos.col + 1);
      }
    }

    return possiblePositions;
  }

  _addMovePositionIfValid(List<Position> positions, int r, int c)
  {
    if(onBoard(r, c) && !board[r][c].occupied())
    {
      positions.add(new Position(r, c));
    }
  }

  List<Position> possibleJumpsFrom(Position pos)
  {
    List <Position> possibleJumps = [];

    if(!onBoard(pos.row, pos.col))
    {
      throw new Exception('Location ${pos.row}, ${pos.col} is not on the board!');
    }

    if(!board[pos.row][pos.col].occupied())
    {
      throw new Exception('No piece at location ${pos.row}, ${pos.col} !');
    }

    BoardSquare square = board[pos.row][pos.col];

    int direction = square.piece.owner.color == "blue" ? 1 : -1;

    if(square.piece.king)
    {
      _addJumpPositionIfValid(possibleJumps, pos, -2, -2);
      _addJumpPositionIfValid(possibleJumps, pos, -2, 2);
      _addJumpPositionIfValid(possibleJumps, pos, 2, -2);
      _addJumpPositionIfValid(possibleJumps, pos, 2, 2);
    }
    else
    {
      if(direction == 1)
      {
        _addJumpPositionIfValid(possibleJumps, pos, -2, -2);
        _addJumpPositionIfValid(possibleJumps, pos, -2, 2);
      }
      else
      {
        _addJumpPositionIfValid(possibleJumps, pos, 2, -2);
        _addJumpPositionIfValid(possibleJumps, pos, 2, 2);
      }
    }

    return possibleJumps;
  }

  _addJumpPositionIfValid(List<Position> positions, Position pos, int deltaR, int deltaC)
  {
    //If position is ont he board and not occupied
    int rJump = pos.row + deltaR;
    int cJump = pos.col + deltaC;
    if(onBoard(rJump, cJump) && !board[rJump][cJump].occupied())
    {
      //check if intermediate square is occupied and is not the same colored piece as ours
      BoardSquare square = board[pos.row + (deltaR/2).toInt()][pos.col + (deltaC/2).toInt()];
      if(square.occupied() && square.piece.owner != board[pos.row][pos.col].piece.owner)
      {
        positions.add(new Position(rJump, cJump));
      }
    }
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
          }
          else if (r > 4) {
            board[r][c].piece = new BoardPiece(checkersService.player2);
          }
        }
      }
    }
  }

  CheckersBoard clone()
  {
    CheckersBoard cloneBoard = new CheckersBoard(checkersService, BOARD_SIZE);

    for(int r = 0; r < BOARD_SIZE; r++)
    {
      for(int c = 0; c < BOARD_SIZE; c++)
      {
        if(board[r][c].occupied())
        {
          cloneBoard.board[r][c].piece = board[r][c].piece.clone();
        }
      }
    }

    return cloneBoard;
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

  BoardPiece(this.owner, [this.king = false])
  {
    king = false;
  }

  BoardPiece clone()
  {
    return new BoardPiece(owner, king);
  }
}

class Position
{
  int row, col;

  Position(this.row, this.col) {}

  bool equals(Position other)
  {
    return row == other.row && col == other.col;
  }

  Position clone()
  {
    return new Position(row, col);
  }

  toString()
  {
    return "($row, $col)";
  }
}

class Move
{
  Position origin;
  Position destination;

  Move(Position originPos, Position destinationPos)
  {
    origin = originPos.clone();
    destination = destinationPos.clone();
  }

  bool equals(Move other)
  {
    return origin.equals(other.origin) && destination.equals(other.destination);
  }

  toString()
  {
    return "Move From $origin To $destination";
  }
}

class Moves
{
  List<Move> jumps;
  List<Move> moves;

  Moves()
  {
    jumps = [];
    moves = [];
  }

  addJumps(List<Move> jumps)
  {
    this.jumps.addAll(jumps);
  }

  addMoves(List<Move> moves)
  {
    this.moves.addAll(moves);
  }

  bool hasJumps()
  {
    return jumps.isNotEmpty;
  }

  bool hasMoves()
  {
    return moves.isNotEmpty;
  }

  bool outOfMoves()
  {
    return !hasJumps() && !hasMoves();
  }

  bool validJump(Move move)
  {
    bool valid = false;
    int i = 0;

    while(i < jumps.length && !valid)
    {
      valid = jumps[i].equals(move);
      i++;
    }

    return valid;
  }

  bool validMove(Move move)
  {
    bool valid = false;
    int i = 0;

    while(i < moves.length && !valid)
    {
      valid = moves[i].equals(move);
      i++;
    }

    return valid;
  }

  List<Move> getAllPossibleMoves()
  {
    return hasJumps() ? jumps : moves;
  }
}