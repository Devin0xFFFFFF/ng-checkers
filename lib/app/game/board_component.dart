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

  List<int> originPos;
  List<int> targetPos;

  CheckersService checkersService;

  bool continueJump;

  BoardComponent(this.checkersService)
  {
    originPos = [0, 0];
    targetPos = [0, 0];

    continueJump = false;
  }

  dragStart(MouseEvent event, BoardSquare origin, int r, int c)
  {
    //Make sure the current player is the only one who can move
    if(checkersService.currentPlayer == origin.piece.owner)
    {
      //only select a different tile if the move is resolved
      if(!continueJump)
      {
        dragOrigin = origin;
        //Save origin position on board
        originPos[0] = r;
        originPos[1] = c;
        dragOrigin.selected = true;
      }

      event.dataTransfer.effectAllowed = "copyMove";
    }
    //print("ORIGIN @ $r, $c");
    //event.preventDefault();
  }

  dragEnter(MouseEvent event, BoardSquare square, int r, int c)
  {
    if(dragOrigin == null)
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
      targetPos[0] = r;
      targetPos[1] = c;
      event.dataTransfer.dropEffect = "copy";
//      dragTarget = square;
    }

    event.preventDefault();
  }

  dragOver(MouseEvent event, BoardSquare square, int r, int c)
  {
    //For unoccupied tiles, prevent default so cursor can change to copy
    if(!square.occupied())
    {
      event.preventDefault();
    }
  }

  dragLeave(MouseEvent event, BoardSquare square, int r, int c)
  {
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
    if(dragOrigin == null)
    {
      return;
    }

    dragOrigin.selected = false;
    dragTarget?.selected = false;
    if(dragTarget != null && !dragTarget.occupied())
    {
      //print("VALID @ $r, $c");
      bool validPos = true;
      //check against the possible positions to see if you are attempting to move to a valid place
      if(continueJump)
      {
        List<Position> possibleJumpPositions = checkersService.board.possibleJumpsFrom(originPos[0], originPos[1]);
        validPos = false;
        for(Position pos in possibleJumpPositions)
        {
          validPos = pos.row == targetPos[0] && pos.col == targetPos[1];
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
    if(checkersService.board.movePiece(
        originPos[0], originPos[1],
        targetPos[0], targetPos[1]))
    {
      //calculate distance to check if you moved > 1 tile, if so you have jumped
      int colDistance = targetPos[1] - originPos[1];
      //Only check tiles if we have jumped
      List<Position> possibleJumpsFrom = colDistance > 1 || colDistance < -1 ? checkersService.board.possibleJumpsFrom(targetPos[0], targetPos[1]) : [];
      if(possibleJumpsFrom.isNotEmpty)
      {
        print("CAN JUMP AGAIN");
        continueJump = true;
        //update origin to new position
        originPos[0] = targetPos[0];
        originPos[1] = targetPos[1];
      }
      else
      {
        continueJump = false;
        checkersService.takeTurn();
      }
    }

    print("MADE MOVE");

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
