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

getCellSymbol(emptyCell, ' ').
getCellSymbol(whiteCell, 'O').
getCellSymbol(blackCell, '#').
getCellSymbol(_, '?').

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
