%Game Class

% Game(0) - the board state
% Game(1) - List with the number of pieces of each players
% Game(2) - the current player turn
% Game(3) - Game mode

createPvPGame(Game):-
	initialBoard(Board),
	Game = [Board, [3, 3], blackPlayer, pvp], !.
createPvBGame(Game):-
	initialBoard(Board),
	Game = [Board, [3, 3], blackPlayer, pvb], !.
createBvBGame(Game):-
	initialBoard(Board),
	Game = [Board, [3, 3], blackPlayer, bvb], !.

%========================%
%= @@ getters & setters =%
%========================%

get_game_board([Board|_], Board).

get_game_mode(Game, Mode):-
	getListElemAt(3, Game, Mode).

get_game_player_turn(Game, Player):-
  getListElemAt(2, Game, Player).
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
