:-include('utilities.pl').
:-include('containers.pl').
:-include('menus.pl').
:-include('display_game.pl').
:-include('game.pl').

play:-
  main_menu.

player(whitePlayer).
player(blackPlayer).

piece(whitePiece).
piece(blackPiece).

piece_owner(whiteCell, whitePlayer).
piece_owner(blackCell, blackPlayer).

:-dynamic bot_diff/1.
bot_diff(easy).

%p = player, b = bot
game_mode(pvp).
game_mode(pvb).
game_mode(bvb).

play_game(Game):-
  % game_over(board, winner), !, announce(result).
  false, !.

play_game(Game):-
  human_play(Game, TempGame),
  play_game(TempGame).

human_play(Game, ResultantGame):-
  get_game_board(Game, Board), get_game_player_turn(Game,Player),

  clear_console,
  display_game(Board, Player),
  get_piece_source_coords(SrcLine, SrcColumn),
  validate_chosen_piece_ownership(SrcLine, SrcColumn, Board, Player),

  clear_console,
  display_game(Board, Player),
  get_piece_destiny_coords(DestLine, DestColumn),
  validate_coordinates_different(SrcLine, SrcColumn, DestLine, DestColumn),

  validate_move(SrcLine, SrcColumn, DestLine, DestColumn, Game),
  move(SrcLine, SrcColumn, DestLine, DestColumn, Game, ResultantGame), !.


%==============================================%
%= @@ board validation/manipulation functions =%
%==============================================%

validate_chosen_piece_ownership(SrcLine, SrcColumn, Board, Player):-
	getMatrixElemAt(SrcLine, SrcColumn, Board, Piece),
	piece_owner(Piece, Player), !.

validate_chosen_piece_ownership(_, _, _, _):-
	write('# INVALID PIECE!'), nl,
	write('# A player can only move his/her own pieces.'), nl,
	print_enter_to_continue, nl,
	fail.

validate_coordinates_different(SrcLine, SrcColumn, DestLine, DestColumn):-
	(SrcLine \= DestLine ; SrcColumn \= DestColumn), !.

validate_coordinates_different(_, _, _, _):-
	write('# INVALID INPUT!'), nl,
	write('T# he source and destiny coordinates must be different.'), nl,
	print_enter_to_continue, nl,
	fail.

validate_move(SrcLine, SrcColumn, DestLine, DestColumn, Game):-
  validate_X_move(SrcLine, SrcColumn, DestLine, DestColumn, Game);
  validate_Y_move(SrcLine, SrcColumn, DestLine, DestColumn, Game).
  % validate_XY_move(SrcLine, SrcColumn, DestLine, DestColumn, Game).

validate_X_move(SrcLine, SrcColumn, DestLine, DestColumn, Game):-
  DiffLine is DestLine - SrcLine,
  DiffColumn is DestColumn - SrcColumn,
  DiffLine == 0, DiffColumn \= 0,
  validate_X_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Game, DiffColumn, 0).

validate_X_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Game, Direction, CurrIndex):-
  get_game_board(Board, Game),
  SrcColumn + CurrIndex == 4, CurrIndex \= 0;
  SrcColumn + CurrIndex == 0, CurrIndex \= 0;
  (
    Direction > 0 -> (
      CurrIndex is CurrIndex +1,
      getMatrixElemAt(SrcLine, SrcColumn + CurrIndex, Board, SrcElem),
      (
        SrcElem == emptyCell -> true;
        SrcElem \= emptyCell, SrcColumn + CurrIndex == DestColumn +1 -> true;
        false
      )
    );
    Direction < 0 -> (
      CurrIndex is CurrIndex -1,
      getMatrixElemAt(SrcLine, SrcColumn + CurrIndex, Board, SrcElem),
      (
        SrcElem == emptyCell -> true;
        SrcElem \= emptyCell, SrcColumn + CurrIndex == DestColumn -1 -> true;
        false
      )
    )
  ),
  validate_X_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Game, Direction, CurrIndex).


validate_Y_move(SrcLine, SrcColumn, DestLine, DestColumn, Game):-
  DiffLine is DestLine - SrcLine,
  DiffColumn is DestColumn - SrcColumn,
  DiffLine \= 0, DiffColumn == 0,
  validate_Y_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Game, DiffLine, 0).

validate_Y_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Game, Direction, CurrIndex):-
  get_game_board(Board, Game),
  SrcLine + CurrIndex == 4, CurrIndex \= 0;
  SrcLine + CurrIndex == 0, CurrIndex \= 0;
  (
    Direction > 0 -> (
      CurrIndex is CurrIndex +1,
      getMatrixElemAt(SrcLine + CurrIndex, SrcColumn, Board, SrcElem),
      (
        SrcElem == emptyCell -> true;
        SrcElem \= emptyCell, SrcLine + CurrIndex == DestColumn +1 -> true;
        false
      )
    );
    Direction < 0 -> (
      CurrIndex is CurrIndex -1,
      getMatrixElemAt(SrcLine + CurrIndex, SrcColumn, Board, SrcElem),
      (
        SrcElem == emptyCell -> true;
        SrcElem \= emptyCell, SrcLine + CurrIndex == DestColumn -1 -> true;
        false
      )
    )
  ),
  validate_Y_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Game, Direction, CurrIndex).

% validate_XY_move(SrcLine, SrcColumn, DestLine, DestColumn, Game):-
%   DiffLine is DestLine - SrcLine,
%   DiffColumn is DestColumn - SrcColumn,
%   DiffLine \= 0, DiffColumn \= 0, DiffLine == DiffColumn,
%   validate_XY_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Game, DiffLine, DiffColumn, 0, 0).

% validate_XY_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Game, DiffLine, DiffColumn, CurrIndexLine, CurrIndexColumn):-
%   get_game_board(Board, Game),
%   SrcLine + CurrIndexLine == 4, CurrIndexLine \= 0;
%   SrcLine + CurrIndexLine == 0, CurrIndexLine \= 0;
%   SrcColumn + CurrIndexColumn == 4, CurrIndexColumn \= 0;
%   SrcColumn + CurrIndexColumn == 0, CurrIndexColumn \= 0;
%   (
%
%   )



move(SrcLine, SrcColumn, DestLine, DestColumn, Game, ResultantGame):-
  get_game_board(Game, Board),
  getMatrixElemAt(SrcLine, SrcColumn, Board, SrcElem),
  setMatrixElemAtWith(SrcLine, SrcColumn, emptyCell, Board, TempBoard),
  setMatrixElemAtWith(DestLine, DestColumn, SrcElem, TempBoard, ResultantBoard),
  set_game_board(ResultantBoard, Game, ResultantGame).

change_turn(Game, ResultantGame):-
  get_game_player_turn(Game, Player),
  (
    Player == whitePlayer -> NextPlayer = blackPlayer;
    NextPlayer = whitePlayer
  ),
  set_game_player_turn(NextPlayer, Game, ResultantGame).

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
	get_int(RawSrcLine),
	get_code(RawSrcColumn),

	discard_input_char,

	% process row and column
	SrcLine is RawSrcLine-1,
	SrcColumn is RawSrcColumn-48-48-1.
