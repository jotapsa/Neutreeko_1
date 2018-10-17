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
        print_enter_to_continue
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
  print_enter_to_continue, !.

%Game is over when the same board is achieved three times - DRAW
play_game(Game):-
  %assert_draw,
  clear_console,
  get_game_board(Game, Board), display_game(Board),
  write('# Game ended in draw! The same configuration on the board was achieved three times'), nl,
  print_enter_to_continue, !.

% Game Cycle TP1

% play_game(Game):-
%   get_game_board(Game, Board),
%   display_game(Board),
%   waitForEnter.

human_play(Game, ResultantGame):-
  get_game_board(Game, Board), get_game_player_turn(Game,Player),

  clear_console,
  display_game(Board),
  print_turn_info(Player),nl,nl,
  get_piece_source_coords(SrcLine, SrcColumn),
  % validate_chosen_piece_ownership(SrcLine, SrcColumn, Board, Player),

  clear_console,
  display_game(Board),
  print_turn_info(Player),nl,nl,
  get_piece_destiny_coords(DestLine, DestColumn).


%==============================================%
%= @@ board validation/manipulation functions =%
%==============================================%

%===========================%
%= @@ game input functions =%
%===========================%

get_piece_source_coords(SrcLine, SrcColumn):-
	write('Please insert the coordinates of the piece you wish to move and press <Enter> - example: 3f.'), nl,
	input_coords(SrcLine, SrcColumn), nl.

get_piece_destiny_coords(SrcLine, SrcColumn):-
  write('Please insert the destiny coordinates that piece and press <Enter>'), nl,
  input_coords(SrcLine, SrcColumn), nl.

input_coords(SrcLine, SrcColumn):-
	% read row
	get_int(RawSrcLine),

	% read column
	get_int(RawSrcColumn),

	% discard enter
	discard_input_char,

	% process row and column
	SrcLine is RawSrcLine-1,
	SrcColumn is RawSrcColumn-49.
