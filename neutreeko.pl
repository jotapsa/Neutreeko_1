:-include('utilities.pl').
:-include('containers.pl').
:-include('menus.pl').
:-include('game.pl').

neutreeko:-
  mainMenu.

player(whitePlayer).
player(blackPlayer).

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


play_game(Game):-
  % assert_game_not_over(Game),
  (
    %bvb
    (get_game_mode(Game, Mode), Mode == bvb) -> (
      get_game_board(Game, Board), get_game_player_turn(Game,Player),
      display_game(Board),
      !
    );
    %pvp or pvb
    (
      human_play(Game, ResultantGame),
      (
        (get_game_mode(Game,Mode), Mode == pvp) -> (play_game(ResultantGame), !);
        pressEnterToContinue
        % (bot_play(ResultantGame, BotResultantGame), play_game(BotResultantGame))
      )
    )
  ).

play_game(Game):-
  %game over,
  true.

% Game Cycle TP1

% play_game(Game):-
%   get_game_board(Game, Board),
%   display_game(Board),
%   waitForEnter.

human_play(Game, ResultantGame):-
  get_game_board(Game, Board), get_game_turn(Game,Player),

  clearConsole,
  display_game(Board),
  print_turn_info(Player),nl,nl.

%===========================%
%= @@ game input functions =%
%===========================%

get_piece_source_coords(SrcRow, SrcCol):-
	write('Please insert the coordinates of the piece you wish to move and press <Enter> - example: 3f.'), nl,
	inputCoords(SrcRow, SrcCol), nl.

inputCoords(SrcRow, SrcCol):-
	% read row
	getInt(RawSrcRow),

	% read column
	getInt(RawSrcCol),

	% discard enter
	discardInputChar,

	% process row and column
	SrcRow is RawSrcRow-1,
	SrcCol is RawSrcCol-49.
