:-include('utilities.pl').
:-include('containers.pl').
:-include('menus.pl').
:-include('display_game.pl').
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
  % assert_draw(Game)
  % assert_win(Game),
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

%Game is over when a player makes three in a Row - WIN
play_game(Game):-
  %assert_win(Game),
  clear_console,
  get_game_board(Game, Board), display_game(Board),
  get_game_player_turn(Game, Player),
  (
    Player == whitePlayer -> (write('# Game over. Black player won!'), nl);
    Player == blackPlayer -> (write('# Game over. White player won!'), nl);

    write('# ERROR!')
  ),
  pressEnterToContinue, !.

%Game is over when the same board is achieved three times - DRAW
play_game(Game):-
  %assert_draw,
  clear_console,
  get_game_board(Game, Board), display_game(Board),
  write('# Game ended in draw! The same configuration on the board was achieved three times'), nl,
  pressEnterToContinue, !.

% Game Cycle TP1

% play_game(Game):-
%   get_game_board(Game, Board),
%   display_game(Board),
%   waitForEnter.

human_play(Game, ResultantGame):-
  get_game_board(Game, Board), get_game_player_turn(Game,Player),

  clear_console,
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
