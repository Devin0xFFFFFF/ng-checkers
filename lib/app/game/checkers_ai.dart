import 'package:ng_checkers/app/game/checkers_board.dart';
import 'package:ng_checkers/app/game/player.dart';
import 'dart:math';

class CheckersAI
{
  static Move determineMove(Player player, Moves moves, CheckersBoard board, [depth = 4])
  {
    //TODO: select the best first move
    //TODO: recurse

    CheckersBoard cloneBoard = board.clone();
    return _recursivelyDetermineMove(player, moves, cloneBoard, 0, depth);
  }

  static Move _recursivelyDetermineMove(Player player, Moves moves, CheckersBoard board, int currentDepth, int maxDepth)
  {
    //TODO: put in logic for this
    List<Move> ms = moves.hasJumps() ? moves.jumps : moves.moves;

    Random random = new Random();
    Move move = ms[random.nextInt(ms.length)];

    return move;
  }

  static Move _selectBestMove(Moves moves)
  {
    List<Move> validMoves = moves.hasJumps() ? moves.jumps : moves.moves;
    List<double> evaluatedMoves = new List<double>(validMoves.length);

    int bestMove = 0;
    double bestEvaluation = 0.0;

    for(int i = 0; i < validMoves.length; i++)
    {
      evaluatedMoves[i] = _evaluateMove(validMoves[i]);
      if(evaluatedMoves[i] > bestEvaluation)
      {
        bestEvaluation = evaluatedMoves[i];
        bestMove = i;
      }
    }

    return validMoves[bestMove];
  }

  static double _evaluateMove(Move move)
  {
    return 0.0;
  }
}