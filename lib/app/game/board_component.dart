// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:ng_checkers/app/game/checkers_board.dart';
import 'dart:html';
import 'package:ng_checkers/app/game/checkers_service.dart';

@Component(selector: 'ck-board',
    templateUrl: 'board_component.html',
    directives: const [COMMON_DIRECTIVES])
class BoardComponent
{
  BoardSquare dragOrigin;
  BoardSquare dragTarget, tempDragTarget;

  Position originPos;
  Position targetPos;

  CheckersService checkersService;

  bool continueJump;

  BoardComponent(this.checkersService)
  {
    originPos = new Position(0,0);
    targetPos = new Position(0,0);

    continueJump = false;
  }

  dragStart(MouseEvent event, BoardSquare origin, int r, int c)
  {
    //Make sure the current player is the only one who can move

    if(checkersService.currentPlayer == origin.piece.owner && !checkersService.AITurn())
    {
      //only select a different tile if the move is resolved
      if(!continueJump)
      {
        dragOrigin = origin;
        //Save origin position on board
        originPos.row = r;
        originPos.col = c;
        dragOrigin.selected = true;
      }

      event.dataTransfer.effectAllowed = "copyMove";
    }
    //print("ORIGIN @ $r, $c");
    //event.preventDefault();
  }

  dragEnter(MouseEvent event, BoardSquare square, int r, int c)
  {
    if(dragOrigin == null || checkersService.AITurn())
    {
      return;
    }

    if(square.occupied())
    {
      //print("OCCUPIED @ $r, $c");
      tempDragTarget = null;
    }
    else
    {
      //print("VACANT @ $r, $c");
      tempDragTarget = square;
      targetPos.row = r;
      targetPos.col = c;
      event.dataTransfer.dropEffect = "copy";
//      dragTarget = square;
    }

    event.preventDefault();
  }

  dragOver(MouseEvent event, BoardSquare square, int r, int c)
  {
    //For unoccupied tiles, prevent default so cursor can change to copy
    if(!square.occupied() &&  checkersService.validMove(new Move(originPos, new Position(r, c))) && !checkersService.AITurn())
    {
      event.preventDefault();
    }
  }

  dragLeave(MouseEvent event, BoardSquare square, int r, int c)
  {
    if(checkersService.AITurn())
    {
      return;
    }

    dragTarget?.selected = false;
    dragTarget = tempDragTarget;
    if(dragTarget != null)
    {
      dragTarget.selected = true;
    }

    //print("LEAVING @ $r, $c");
  }

  dragEnd(MouseEvent event, BoardSquare square, int r, int c)
  {
    if(dragOrigin == null || checkersService.AITurn())
    {
      return;
    }

    dragOrigin.selected = false;
    dragTarget?.selected = false;
    if(dragTarget != null && !dragTarget.occupied())
    {
      //print("VALID @ $r, $c");
      bool validPos = checkersService.validMove(new Move(originPos, targetPos));
      //check against the possible positions to see if you are attempting to move to a valid place
      if(validPos && continueJump)
      {
        List<Position> possibleJumpPositions = checkersService.board.possibleJumpsFrom(originPos);
        validPos = false;
        for(Position pos in possibleJumpPositions)
        {
          validPos = pos.equals(targetPos);
          if(validPos)
          {
            break;
          }
        }
      }

      if(validPos)
      {
        makeMove();
      }
    }
    else
    {
      //print("INVALID @ $r, $c");
    }
  }

  makeMove()
  {
    Move move = new Move(originPos, targetPos);

    if(checkersService.board.movePiece(move))
    {
      //if we can make another jump, continue turn, else end turn
      if(checkersService.attemptContinueJumps(move))
      {
        continueJump = true;
        //update origin to new jumped-to position
        originPos = targetPos.clone();
      }
      else
      {
        continueJump = false;
        checkersService.takeTurn();
      }
    }

    //update the drag origin to be the new position
    if(continueJump)
    {
      dragOrigin = dragTarget;
      dragOrigin.selected = true;
    }
    else
    {
      dragOrigin = null;
    }

    dragTarget = null;
  }
}
