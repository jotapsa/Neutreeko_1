%Game List

% Game(0) - the board state
% Game(1) - the current player turn
% Game(2) - Game mode

createPvPGame(Game):-
	initialBoard(Board),
	Game = [Board, blackPlayer, pvp], !.
createPvBGame(Game):-
	initialBoard(Board),
	Game = [Board, blackPlayer, pvb], !.
createBvBGame(Game):-
	initialBoard(Board),
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

initialBoard([
  [emptyCell,whiteCell,emptyCell,whiteCell,emptyCell],
  [emptyCell,emptyCell,blackCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,whiteCell,emptyCell,emptyCell],
  [emptyCell,blackCell,emptyCell,blackCell,emptyCell]
  ]).

test_board_1([
  [whiteCell,whiteCell,emptyCell,emptyCell,blackCell],
  [blackCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,whiteCell,emptyCell,emptyCell,emptyCell]
  ]).

final_board([
  [emptyCell,whiteCell,whiteCell,whiteCell,emptyCell],
  [emptyCell,emptyCell,blackCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,blackCell,emptyCell,blackCell,emptyCell]
  ]).
