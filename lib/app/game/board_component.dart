// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:ng_checkers/app/game/checkers_board.dart';
import 'dart:html';

@Component(selector: 'ck-board',
    templateUrl: 'board_component.html',
    directives: const [COMMON_DIRECTIVES])
class BoardComponent
{
  CheckersBoard board;

  BoardSquare dragOrigin;
  BoardSquare dragTarget, tempDragTarget;

  BoardComponent()
  {
    board = new CheckersBoard("p1", "p2");
  }

  dragStart(MouseEvent event, BoardSquare origin, int r, int c)
  {
    dragOrigin = origin;
    print("ORIGIN @ $r, $c");
    //event.preventDefault();
  }

  dragEnter(MouseEvent event, BoardSquare square, int r, int c)
  {
    if(square.occupied())
    {
      print("OCCUPIED @ $r, $c");
      tempDragTarget = null;
    }
    else
    {
      print("VACANT @ $r, $c");
      tempDragTarget = square;
//      dragTarget = square;
    }

    event.preventDefault();
  }

  dragLeave(MouseEvent event, BoardSquare square, int r, int c)
  {
    dragTarget = null;
    dragTarget = tempDragTarget;
    print("LEAVING @ $r, $c");
  }

  dragEnd(MouseEvent event, BoardSquare square, int r, int c)
  {
    if(validMove())
    {
      print("VALID @ $r, $c");
      makeMove();
    }
    else
    {
      print("INVALID @ $r, $c");
    }
  }

  bool validMove()
  {
    return dragTarget != null && !dragTarget.occupied();
  }

  makeMove()
  {
    dragTarget.piece = dragOrigin.piece;
    dragOrigin.piece = null;

    print("MADE MOVE");

    //TODO: remove any pieces, check for an additional move

    //TODO: check for king-ing

    dragOrigin = null;
    dragTarget = null;
  }
}
