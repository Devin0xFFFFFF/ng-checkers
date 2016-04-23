# ng-checkers

### Checkers (Draughts) created with Angular 2 and Dart

##About

This project is an implementation of the game of checkers, also known as draughts, written in Dart using the Angular 2 framework.

It supports both local versus play and a local versus AI mode.

I am working towards adding a websockets based multiplayer mode.

##Running This Project

There are two ways of running this project: Docker or straight Dart

###Docker

For running the app with docker and serving it via Nginx, you will need to have an up to date version of Docker and Docker Compose.

You can then 'docker-compose build' and 'docker-compose up -d' in this directory to run the app.

It should be running by default on 'localhost:80'

If you wish to terminate the app, use 'docker-compose kill'

###Dart

To run this project with Dart you will require a copy of the Dart SDK, which includes the pub package manager. The [Download Page](https://www.dartlang.org/downloads/) contains OS specific instructions.

First, make sure to run pub get / pub upgrade in the project root to retrieve packages.

Then, run pub build to compile Dart code to JavaScript. The generated JavaScript appears, along with supporting files, under the build directory.

Run the index.html in the build directory from a browser to play the game.

##References

- [Angular 2 Dart Reference Repo](https://github.com/Devin0xFFFFFF/angular2_dart)
- [Checkers in Java](http://math.hws.edu/eck/cs124/javanotes3/source/Checkers.java)
- [HTML5 DOM Events](http://www.w3schools.com/jsref/dom_obj_event.asp)
- [Reference Online Checkers](https://www.mathsisfun.com/games/checkers-2.html)

##Rules of Checkers (Draughts)

1. Checkers is played by two players. Each player begins the game with 12 colored discs. (Typically, one set of pieces is black and the other red.)
2. The board consists of 64 squares, alternating between 32 dark and 32 light squares. It is positioned so that each player has a light square on the right side corner closest to him or her.
3. Each player places his or her pieces on the 12 dark squares closest to him or her.
4. Black moves first. Players then alternate moves.
5. Moves are allowed only on the dark squares, so pieces always move diagonally. Single pieces are always limited to forward moves (toward the opponent).
6. A piece making a non-capturing move (not involving a jump) may move only one square.
7. A piece making a capturing move (a jump) leaps over one of the opponent's pieces, landing in a straight diagonal line on the other side. Only one piece may be captured in a single jump; however, multiple jumps are allowed on a single turn.
8. When a piece is captured, it is removed from the board.
9. If a player is able to make a capture, there is no option -- the jump must be made. If more than one capture is available, the player is free to choose whichever he or she prefers.
10. When a piece reaches the furthest row from the player who controls that piece, it is crowned and becomes a king. One of the pieces which had been captured is placed on top of the king so that it is twice as high as a single piece.
11. Kings are limited to moving diagonally, but may move both forward and backward. (Remember that single pieces, i.e. non-kings, are always limited to forward moves.)
12. Kings may combine jumps in several directions -- forward and backward -- on the same turn. Single pieces may shift direction diagonally during a multiple capture turn, but must always jump forward (toward the opponent).
13. A player wins the game when the opponent cannot make a move. In most cases, this is because all of the opponent's pieces have been captured, but it could also be because all of his pieces are blocked in.
