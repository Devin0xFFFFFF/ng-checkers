import 'package:angular2/angular2.dart';
import 'package:ng_checkers/app/game/checkers_board.dart';

@Injectable()
class CheckersService
{
  int turn;

  CheckersBoard board;

  Player player1, player2;

  Player currentPlayer;

  CheckersService()
  {
    turn = 1;

    board = new CheckersBoard(this);

    createPlayers("p1", "p2");

    currentPlayer = player1;

    board.addPieces();
  }

  createPlayers(String player1Name, String player2Name)
  {
    player1 = new Player(player1Name, "red", board);
    player2 = new Player(player2Name, "blue", board);
  }

  takeTurn()
  {
    if(!gameOver())
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
    }
    else
    {
      print("GAME OVER!!!");
    }
  }

  bool gameOver()
  {
    return player1.pieces <= 0 || player2.pieces <= 0;
  }
}