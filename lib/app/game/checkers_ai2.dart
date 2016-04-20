import 'package:ng_checkers/app/game/checkers_board.dart';
import 'package:ng_checkers/app/game/player.dart';
import 'dart:math';

class CheckersAI2
{
  static Move determineMove(Player player, Player opponent, CheckersBoard board, [int depth = 5])
  {
    List<Move> possibleMoves = getPossibleMoves(board, player);

    Move bestMove = possibleMoves[0];
    double bestMoveValue = 0.0;
    double moveValue = 0.0;

    //for each move
    for(Move move in possibleMoves)
    {
      CheckersBoard cloneBoard = board.clone();
      //recursively evaluate
      moveValue = recursivelyEvaluate(player, opponent, move, cloneBoard, 1, 1, depth);
      print('Evaluation for $move : $moveValue');

      //select greatest one
      if(moveValue > bestMoveValue)
      {
        bestMoveValue = moveValue;
        bestMove = move;
      }
    }

    print('Selected $bestMove');

    return bestMove;
  }

  static double recursivelyEvaluate(Player player, Player opponent,
      Move move, CheckersBoard prevBoard, int signFactor,
      int currentDepth, int maxDepth)
  {
    //clone board
    CheckersBoard board = prevBoard.clone();

    //make move
    board.movePiece(move);

    //get available jumps to check for continuing a jump
    List<Move> availableJumps = move.isJump() ? getAvailableJumps(move.destination, board) : [];

    if(availableJumps.isNotEmpty)
    {
      board = continueJump(board, player, availableJumps);
    }

    //calculate board value
    double boardValue = evaluateBoard(player, board);

    //if depth > maxDepth, return 0
    if(currentDepth > maxDepth)
    {
      return 0.0;
    }

    //get possible moves
    List<Move> possibleMoves = getPossibleMoves(board, player);

    //if no possible moves, return large value, as it is either win / loss
    if(possibleMoves == [])
    {
      return signFactor * -10.0; //if you lose, or if opponent loses, create incentive / fear
    }

    double bestEvaluation = 0.0;
    double currentEvaluation = 0.0;

    Random random = new Random();

    //for each move
    for(int i = 0; i < possibleMoves.length; i++)
    {
      double epsilon = random.nextDouble()/10; //0 - 0.1, exclusive
      //recursively evaluate with inverse player (+ some random epsilon to break ties)
      currentEvaluation = recursivelyEvaluate(opponent, player, possibleMoves[i],
          board, -signFactor, currentDepth + 1, maxDepth) + (signFactor * epsilon);

      //select the move with the highest value
      if(currentEvaluation > bestEvaluation)
      {
        bestEvaluation = currentEvaluation;
      }
    }

    //sum that value into evaluation
    boardValue += bestEvaluation;

    //return the evaluation * sign value, to denote a benefit to player (1)
    //or a penalty for opponent move (-1)
    return signFactor * boardValue;
  }

  static List<Move> getPossibleMoves(CheckersBoard board, Player player)
  {
    Moves moves = board.getPossibleMoves(player);
    List<Move> possibleMoves = moves.hasJumps() ? moves.jumps : moves.moves;
    return possibleMoves;
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

  static List<Move> getAvailableJumps(Position pos, CheckersBoard board)
  {
    List<Move> possibleJumps = [];
    List<Position> possibleJumpsFrom = board.possibleJumpsFrom(pos);

    if(possibleJumpsFrom.isNotEmpty)
    {
      possibleJumpsFrom.forEach((Position jumpPos){
        possibleJumps.add(new Move(pos, jumpPos));
      });
    }

    return possibleJumps;
  }

  static CheckersBoard continueJump(CheckersBoard sourceBoard, Player player, List<Move> jumps)
  {
    List<Move> availableJumps = jumps;

    double jumpValue;
    double bestJumpValue = -100.0;
    CheckersBoard bestJumpBoard;
    Position bestJumpPosition;

    CheckersBoard board = sourceBoard.clone();
    CheckersBoard afterJumpBoard;

    bool updated;

    //keep making a jump, each time selecting the best of the possible jumps
    while(availableJumps.isNotEmpty)
    {
      updated = false;
      for(int i = 0; i < availableJumps.length; i++)
      {
        //clone board, make jump, evaluate
        afterJumpBoard = board.clone();
        if(!afterJumpBoard.movePiece(availableJumps[i]))
        {
          afterJumpBoard.movePiece(availableJumps[i]);
          throw new Exception('Failed to Continue Jump!');
        }
        jumpValue = evaluateBoard(player, afterJumpBoard);

        //continuously select the best board
        if(jumpValue > bestJumpValue)
        {
          updated = true;
          bestJumpValue = jumpValue;
          bestJumpBoard = afterJumpBoard;
          bestJumpPosition = availableJumps[i].destination;
        }
      }

      availableJumps = getAvailableJumps(bestJumpPosition, bestJumpBoard);
      bestJumpValue = -100.0;
      board = bestJumpBoard;
      bestJumpPosition = null;
    }

    return board;
  }

  static bool what(Position p, CheckersBoard b)
  {
    return !b.at(p).occupied();
  }
}