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

%%% gets the board of the game specified.
%%% 1. game; 2. board of game.
getGameBoard([Board|_], Board).

initialBoard([
  [emptyCell,whiteCell,emptyCell,whiteCell,emptyCell],
  [emptyCell,emptyCell,blackCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,whiteCell,emptyCell,emptyCell],
  [emptyCell,blackCell,emptyCell,blackCell,emptyCell]
  ]).

display_game(Board):-
  display_board(Board, 0),
  printLine, nl,
  printLetters.

display_board([],_).
display_board([Line|Tail], Y):-
  printLine, nl,
  printSpaces, nl,
  Y1 is Y+1,
  display_line(Line, Y1), nl,
  printSpaces, nl,
  display_board(Tail, Y1).

display_line(Line, Y):-
  write(Y), write('  |'),
  display_line_aux(Line).

display_line_aux([]).
display_line_aux([Cell|Tail]):-
  getSymbol(Symbol,Piece),
  write(' '), write(Piece), write('  | '),

getSymbol(emptyCell, ' ').
getSymbol(whiteCell, 'X').
getSymbol(blackCell, 'Y').
