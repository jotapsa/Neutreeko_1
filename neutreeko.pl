:-include('utilities.pl').
:-include('menus.pl').
:-include('game.pl').

neutreeko:-
  mainMenu.

player(whitePlayer).
player(blackPlayer).

getPlayerName(whitePlayer, 'White').
getPlayerName(blackPlayer, 'Black').

piece(whitePiece).
piece(blackPiece).

pieceIsOwnedBy(whiteCell, whitePlayer).
pieceIsOwnedBy(blackCell, blackPlayer).

% currentPlayerOwnsCell(Row, Col, Game):-
% 	getGameBoard(Game, Board), getGamePlayerTurn(Game, Player),
% 	getMatrixElemAt(Row, Col, Board, Cell), pieceIsOwnedBy(Cell, Player).

%p = player, b = bot
gameMode(pvp).
gameMode(pvb).
gameMode(bvb).


% Game Cycle

playGame(Game):-
  getGameBoard(Game, Board),
  display_game(Board).
