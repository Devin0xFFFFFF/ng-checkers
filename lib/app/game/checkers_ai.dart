import 'package:ng_checkers/app/game/checkers_board.dart';
import 'package:ng_checkers/app/game/player.dart';
import 'dart:math';

class CheckersAI
{
  static Move determineMove(Player player, Player opponent, CheckersBoard board, [depth = 3])
  {
    //Clone the board, so as not to effect game board
    Moves moves = board.getPossibleMoves(player);
    List<Move> possibleMoves = moves.hasJumps() ? moves.jumps : moves.moves;

    //We can assume there is at least one move, or else game is over
    Move bestMove = possibleMoves[0];
    double bestMoveValue = 0.0;
    double moveValue = 0.0;

    for(Move move in possibleMoves)
    {
      CheckersBoard cloneBoard = board.clone();
      moveValue = recursivelyEvaluate(player, opponent, move, cloneBoard, 1, 1, depth);

      if(moveValue > bestMoveValue)
      {
        bestMoveValue = moveValue;
        bestMove = move;
      }
    }

   return bestMove;
  }

  static double recursivelyEvaluate(Player player, Player opponent, Move move, CheckersBoard board, int signFactor, int currentDepth, int maxDepth)
  {
    board.movePiece(move);
    List<Move> continueJumps = getContinueJumps(move, board);

    Moves moves = board.getPossibleMoves(opponent);
    List<Move> possibleMoves = moves.hasJumps() ? moves.jumps : moves.moves;

    if(currentDepth > maxDepth)
    {
      return 0.0;
    }
    else if(possibleMoves == [])
    {
      return signFactor * -10.0; //if you lose, or if opponent loses, create incentive
    }

    double bestEvaluation = 0.0;
    double currentEvaluation = 0.0;

    for(int i = 0; i < possibleMoves.length; i++)
    {
      CheckersBoard nextBoard = board.clone();
      //board.movePiece(possibleMoves[i]);
      currentEvaluation = 1/currentDepth * (1 + signFactor * evaluateBoard(player, nextBoard)) + recursivelyEvaluate(opponent, player, possibleMoves[i], nextBoard, -signFactor, currentDepth + 1, maxDepth);
      print("${player} : ${move} : ${currentEvaluation}");

      if(currentEvaluation > bestEvaluation)
      {
        bestEvaluation = currentEvaluation;
      }
    }

    return bestEvaluation;
  }

  static double evaluateBoard(Player player, CheckersBoard board)
  {
    double value = 0.0;

    for(int r = 0; r < board.BOARD_SIZE; r++)
    {
      for(int c = 0; c < board.BOARD_SIZE; c++)
      {
        BoardSquare square = board.at(new Position(r, c));
        if(square.occupied())
        {
          if(square.piece.owner == player)
          {
            value += square.piece.king ? 2 : 1;
          }
          else
          {
            value -= square.piece.king ? 2 : 1;
          }
        }
      }
    }

    return value;
  }

  static List<Move> getContinueJumps(Move jumpMove, CheckersBoard board)
  {
    Moves possibleCurrentMoves;

    //calculate distance to check if you moved > 1 tile, if so you have jumped
    int colDistance = jumpMove.destination.col - jumpMove.origin.col;
    //Only check tiles if we have jumped
    List<Position> possibleJumpsFrom = colDistance > 1 || colDistance < -1 ? board.possibleJumpsFrom(jumpMove.destination) : [];

    if(possibleJumpsFrom.isNotEmpty)
    {
      //set possibleMoves to be the Moves from the current jump position
      Moves possibleMovesContinuingJump = new Moves();
      possibleJumpsFrom.forEach((Position jumpPos){
        possibleMovesContinuingJump.addJumps([new Move(jumpMove.destination, jumpPos)]);
      });
      possibleCurrentMoves = possibleMovesContinuingJump;

      return possibleCurrentMoves.jumps;
    }

    return [];
  }
//
//  static Move recursivelyDetermineMove(Player player, Player opponent, CheckersBoard board, int signFactor, int currentDepth, int maxDepth)
//  {
//    Moves moves = board.getPossibleMoves(player);
//    List<Move> possibleMoves = moves.hasJumps() ? moves.jumps : moves.moves;
//
//    int bestMove = 0;
//    double bestEvaluation = 0.0;
//    double currentEvaluation = 0.0;
//
//    for(int i = 0; i < possibleMoves.length; i++) {
//      currentEvaluation = 1/currentDepth * signFactor * getMoveValue(player, possibleMoves[i], board) + recursiveBoardValue(opponent, player);
//
//      if (currentEvaluation > bestEvaluation) {
//        bestEvaluation = currentEvaluation;
//        bestMove = i;
//      }
//    }
//
//    return possibleMoves[bestMove];
//  }
}