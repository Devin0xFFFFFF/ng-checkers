// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:ng_checkers/app/pages/checkers_game_page.dart';

@Component(selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [COMMON_DIRECTIVES, CheckersGamePage])
class AppComponent {}
