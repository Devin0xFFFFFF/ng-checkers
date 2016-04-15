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

  BoardComponent(this.checkersService)
  {
    originPos = [0, 0];
    targetPos = [0, 0];
  }

  dragStart(MouseEvent event, BoardSquare origin, int r, int c)
  {
    //Make sure the current player is the only one who can move
    if(checkersService.currentPlayer == origin.piece.owner)
    {
      dragOrigin = origin;
      //Save origin position on board
      originPos[0] = r;
      originPos[1] = c;
      dragOrigin.selected = true;
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
      print("OCCUPIED @ $r, $c");
      tempDragTarget = null;
    }
    else
    {
      print("VACANT @ $r, $c");
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

    print("LEAVING @ $r, $c");
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
      print("VALID @ $r, $c");
      makeMove();
    }
    else
    {
      print("INVALID @ $r, $c");
    }
  }

  makeMove()
  {
    if(checkersService.board.movePiece(
        originPos[0], originPos[1],
        targetPos[0], targetPos[1]))
    {
      checkersService.takeTurn();
    }

    print("MADE MOVE");

    dragOrigin = null;
    dragTarget = null;
  }
}
