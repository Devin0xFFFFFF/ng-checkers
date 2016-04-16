import 'package:angular2/angular2.dart';
import 'package:ng_checkers/app/game/checkers_board.dart';
import 'package:ng_checkers/app/game/player.dart';

@Injectable()
class CheckersService
{
  int turn;

  CheckersBoard board;

  Player player1, player2;

  Player currentPlayer;

  List<Move> possibleCurrentMoves;

  bool gameOver;
  Player winner;

  CheckersService()
  {
    initializeGame();
  }

  createPlayers(String player1Name, String player2Name)
  {
    player1 = new Player(player1Name, "red", board);
    player2 = new Player(player2Name, "blue", board);
  }

  takeTurn()
  {
    turn++;
    if(currentPlayer == player1)
    {
      currentPlayer = player2;
    }
    else
    {
      currentPlayer = player1;
    }

    possibleCurrentMoves = board.getPossibleMoves(currentPlayer);

    if(possibleCurrentMoves.isEmpty)
    {
      gameOver = true;
      winner = currentPlayer == player1 ? player2 : player1;
    }
  }

  bool validMove(Move move)
  {
    bool valid = false;
    int i = 0;

    while(i < possibleCurrentMoves.length && !valid)
    {
      valid = possibleCurrentMoves[i].equals(move);
      i++;
    }

    return valid;
  }

  resetGame()
  {
    initializeGame();
  }

  initializeGame()
  {
    turn = 1;
    gameOver = false;

    //create the initial board
    board = new CheckersBoard(this);

    //create players
    createPlayers("p1", "p2");

    //start with player1
    currentPlayer = player1;

    //add all pieces for the two players to the board
    board.addPieces();

    //get the possible moves for turn 1
    possibleCurrentMoves = board.getPossibleMoves(currentPlayer);
  }

//  bool gameOver()
//  {
//    return player1.pieces <= 0 || player2.pieces <= 0;
//  }
}