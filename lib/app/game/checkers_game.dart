// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:ng_checkers/app/game/board_component.dart';
import 'package:ng_checkers/app/game/checkers_service.dart';

@Component(selector: 'ck-game',
    templateUrl: 'game_component.html',
    directives: const [COMMON_DIRECTIVES, BoardComponent],
    providers: const [CheckersService])
class GameComponent
{
  GameComponent()
  {

  }
}
