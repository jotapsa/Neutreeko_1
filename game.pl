%Game List

% Game(0) - the board state
% Game(1) - the current player turn
% Game(2) - Game mode

createPvPGame(Game):-
	initial_board(Board),
	Game = [Board, blackPlayer, pvp], !.
createPvBGame(Game):-
	initial_board(Board),
	Game = [Board, blackPlayer, pvb], !.
createBvBGame(Game):-
	initial_board(Board),
	Game = [Board, blackPlayer, bvb], !.

%========================%
%= @@ getters & setters =%
%========================%

get_game_board([Board|_], Board).

set_game_board(Board, Game, ResultantGame):-
	setListElemAtWith(0, Board, Game, ResultantGame).

get_game_mode(Game, Mode):-
	getListElemAt(2, Game, Mode).

get_game_player_turn(Game, Player):-
  getListElemAt(1, Game, Player).

set_game_player_turn(Player, Game, ResultantGame):-
	setListElemAtWith(1, Player, Game, ResultantGame).

set_bot_diff(Level):-
  nonvar(Level),
  retract(bot_diff(_)),
  asserta(bot_diff(Level)).
%====================%
%= @@ board presets =%
%====================%

initial_board([
  [emptyCell,whitePiece,emptyCell,whitePiece,emptyCell],
  [emptyCell,emptyCell,blackPiece,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,whitePiece,emptyCell,emptyCell],
  [emptyCell,blackPiece,emptyCell,blackPiece,emptyCell]
  ]).

test_board_1([
  [whitePiece,whitePiece,emptyCell,emptyCell,blackPiece],
  [blackPiece,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,whitePiece,emptyCell,emptyCell,emptyCell]
  ]).


%test_board_2 state expected value - 10000
test_board_2([
  [whitePiece,whitePiece,blackPiece,emptyCell,blackPiece],
  [whitePiece,emptyCell,emptyCell,emptyCell,blackPiece],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell]
  ]).

test_board_3([
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,blackPiece],
  [whitePiece,whitePiece,emptyCell,emptyCell,blackPiece]
  ]).

white_win_board([
  [emptyCell,whitePiece,whitePiece,whitePiece,emptyCell],
  [emptyCell,emptyCell,blackPiece,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,blackPiece,emptyCell,blackPiece,emptyCell]
  ]).

black_win_board([
  [emptyCell,whitePiece,emptyCell,whitePiece,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [whitePiece,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,blackPiece,blackPiece,blackPiece,emptyCell]
  ]).
