import 'package:angular2/angular2.dart';
import 'package:ng_checkers/app/game/checkers_board.dart';
import 'package:ng_checkers/app/game/player.dart';
import 'dart:math';
import 'dart:async';
import 'package:ng_checkers/app/game/checkers_ai.dart';

@Injectable()
class CheckersService
{
  int turn;

  CheckersBoard board;

  bool versusAI;
  String startingPlayer;

  Player player1, player2;

  Player currentPlayer;

  Moves possibleCurrentMoves;

  bool gameOver;
  Player winner;

  Timer _aiTimer, aiSelectOriginTimer, aiSelectDestinationTimer;

  CheckersService()
  {
    //initializeGame();
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

    if(possibleCurrentMoves.outOfMoves())
    {
      gameOver = true;
      winner = currentPlayer == player1 ? player2 : player1;
    }

    if(versusAI && currentPlayer == player1)
    {
      _aiTimer = new Timer(new Duration(seconds: 1), (){
        _makeAIMove();
      });
    }
  }

  bool validMove(Move move)
  {
    //if there is an available jump, we must take it, otherwise can take normal move
    return possibleCurrentMoves.hasJumps() ? possibleCurrentMoves.validJump(move) : possibleCurrentMoves.validMove(move);
  }

  bool validRawMove(int originR, int originC, int targetR, int targetC)
  {
    Move move = new Move(new Position(originR, originC), new Position(targetR, targetC));

    return validMove(move);
  }

  _makeAIMove() async
  {
    //Determine the move the AI will take
    Move move = CheckersAI.determineMove(currentPlayer, possibleCurrentMoves, board);

    //after a duration, highlight the move origin
    aiSelectOriginTimer = new Timer(new Duration(milliseconds: 250), (){
      board.at(move.origin).selected = true;
      //after a duration, highlight move destination
      aiSelectDestinationTimer = new Timer(new Duration(milliseconds: 500), (){
        board.at(move.destination).selected = true;
        //after one last duration, make the move
        _aiTimer = new Timer(new Duration(milliseconds: 500), (){
          board.at(move.origin).selected = false;
          board.at(move.destination).selected = false;

          board.movePiece(move);
          //TODO: check for continue jump
          takeTurn();
        });
      });
    });
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

    _selectStartingPlayer();

    //add all pieces for the two players to the board
    board.addPieces();

    //get the possible moves for turn 1
    possibleCurrentMoves = board.getPossibleMoves(currentPlayer);

    if(versusAI != null && versusAI && currentPlayer == player1)
    {
      _makeAIMove();
    }
  }

  _selectStartingPlayer()
  {
    if(startingPlayer == 'Red')
    {
      currentPlayer = player1;
    }
    else if(startingPlayer == 'Blue')
    {
      currentPlayer = player2;
    }
    else if(startingPlayer == 'Random')
    {
      Random random  = new Random();
      currentPlayer = random.nextBool() ? player1 : player2;
    }
  }
}