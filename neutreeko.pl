:-use_module(library(lists)).
:-use_module(library(random)).
:-include('utilities.pl').
:-include('containers.pl').
:-include('menus.pl').
:-include('display_game.pl').
:-include('game.pl').
:-include('bot.pl').

play:-
  main_menu.

player(whitePlayer).
player(blackPlayer).

piece(whitePiece).
piece(blackPiece).

piece_owner(whitePiece, whitePlayer).
piece_owner(blackPiece, blackPlayer).

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
  get_game_board(Game, Board), get_game_player_turn(Game, Player),

  clear_console,
  display_game(Board, Player),
  get_piece_source_coords(m(Xi, Yi, _, _)),
  validate_chosen_piece_ownership(SrcLine, SrcColumn, Board, Player),

  clear_console,
  display_game(Board, Player),
  get_piece_destiny_coords(m(_, _, Xf, Yf)),
  validate_coordinates_different(Xi, Yi, Xf, Yf),

  validate_move(Xi, Yi, Xf, Yf, Board),
  move(Xi, Yi, Xf, Yf, Game, ResultantGame), !.


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

validate_move(SrcLine, SrcColumn, DestLine, DestColumn, Board):-
  validate_X_move(SrcLine, SrcColumn, DestLine, DestColumn, Board);
  validate_Y_move(SrcLine, SrcColumn, DestLine, DestColumn, Board);
  validate_XY_move(SrcLine, SrcColumn, DestLine, DestColumn, Board).

validate_X_move(SrcLine, SrcColumn, DestLine, DestColumn, Board):-
  DiffLine is DestLine - SrcLine,
  DiffColumn is DestColumn - SrcColumn,
  DiffLine == 0, DiffColumn \= 0,
  (DiffColumn > 0 -> Direction is 1 ; Direction is -1),
  validate_X_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Board, Direction, 0).

validate_X_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Board, Direction, CurrIndex):-
  NewIndex is CurrIndex+Direction,
  NextColumn is SrcColumn+NewIndex,

  getMatrixElemAt(SrcLine, NextColumn, Board, NextElem),
  (
    NextElem == 'emptyCell' -> (NextColumn == DestColumn ->
                                  (AfterColumn is NextColumn+Direction,
                                    getMatrixElemAt(SrcLine, AfterColumn , Board, NextElem) ->
                                      (NextElem == 'emptyCell' -> false ; true) ; true
                                  )
                                 ; validate_X_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Board, Direction, NewIndex)
                               ) ; false
  ).

validate_Y_move(SrcLine, SrcColumn, DestLine, DestColumn, Board):-
  DiffLine is DestLine - SrcLine,
  DiffColumn is DestColumn - SrcColumn,
  DiffLine \= 0, DiffColumn == 0,
  (DiffLine > 0 -> Direction is 1 ; Direction is -1),
  validate_Y_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Board, Direction, 0).

validate_Y_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Board, Direction, CurrIndex):-
  NewIndex is CurrIndex+Direction,
  NextLine is SrcLine+NewIndex,

  getMatrixElemAt(NextLine, SrcColumn, Board, NextElem),
  (
    NextElem == 'emptyCell' -> (NextLine == DestLine ->
                                  (AfterLine is NextLine+Direction,
                                    getMatrixElemAt(AfterLine, DestColumn , Board, NextElem) ->
                                      (NextElem == 'emptyCell' -> false ; true) ; true
                                  )
                                 ; validate_Y_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Board, Direction, NewIndex)
                               ) ; false
  ).

validate_XY_move(SrcLine, SrcColumn, DestLine, DestColumn, Board):-
  DiffLine is DestLine - SrcLine,
  DiffColumn is DestColumn - SrcColumn,
  DiffLine \= 0, DiffColumn \= 0,
  DiffLineAbs is abs(DiffLine), DiffColumnAbs is abs(DiffColumn),
  DiffLineAbs == DiffColumnAbs,
  (DiffLine > 0 -> DirectionLine is 1 ; DirectionLine is -1),
  (DiffColumn > 0 -> DirectionColumn is 1 ; DirectionColumn is -1),
  validate_XY_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Board, DirectionLine, DirectionColumn, 0,0).

validate_XY_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Board, DirectionLine, DirectionColumn, CurrIndexLine, CurrIndexColumn):-
  NewIndexLine is CurrIndexLine+DirectionLine,
  NextLine is SrcLine+NewIndexLine,

  NewIndexColumn is CurrIndexColumn+DirectionColumn,
  NextColumn is SrcColumn+NewIndexColumn,

  getMatrixElemAt(NextLine, NextColumn, Board, NextElem),
  (
    NextElem == 'emptyCell' -> ( (NextLine == DestLine, NextColumn == DestColumn) ->
                                  (AfterLine is NextLine+DirectionLine,
                                   AfterColumn is NextColumn+DirectionColumn,
                                    getMatrixElemAt(AfterLine, AfterColumn, Board, NextElem) ->
                                      (NextElem == 'emptyCell' -> false ; true) ; true
                                  )
                                 ; validate_XY_move_aux(SrcLine, SrcColumn, DestLine, DestColumn, Board, DirectionLine, DirectionColumn, NewIndexLine, NewIndexColumn)
                               ) ; false
  ).


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

get_piece_source_coords(m(Xi, Yi, _, _)):-
	write('Please insert the coordinates of the piece you wish to move and press <Enter> - example: 3f.'), nl,
	input_coords(Xi, Yi), nl.

get_piece_destiny_coords(m( _, _, Xf, Yf)):-
  write('Please insert the destiny coordinates that piece and press <Enter>'), nl,
  input_coords(Xf, Yf), nl.

input_coords(X, Y):-
	get_int(RawSrcLine),
	get_code(RawSrcColumn),

	discard_input_char,

	% process row and column
	X is RawSrcLine-1,
	Y is RawSrcColumn-48-48-1.

checkVertical(Board, Piece) :-
  getMatrixElemAt(X, Y, Board, Piece),
  Piece \= 'emptyCell', X1 is X+1, X2 is X+2,
  getMatrixElemAt(X1, Y, Board, Elem2),
  getMatrixElemAt(X2, Y, Board, Elem3),
  Piece == Elem2, Piece == Elem3.

checkHorizontal(Board, Piece) :-
  getMatrixElemAt(X, Y, Board, Piece),
  Piece \= 'emptyCell', Y1 is Y+1, Y2 is Y+2,
  getMatrixElemAt(X, Y1, Board, Elem2),
  getMatrixElemAt(X, Y2, Board, Elem3),
  Piece == Elem2, Piece == Elem3.

checkDiagonal(Board, Piece) :-  (
  getMatrixElemAt(X, Y, Board, Piece),
  Piece \= 'emptyCell',
  X1 is X+1, X2 is X+2, Y1 is Y+1, Y2 is Y+2,
  getMatrixElemAt(X1, Y1, Board, Elem2),
  getMatrixElemAt(X2, Y2, Board, Elem3),
  Piece == Elem2, Piece == Elem3
  );
  (getMatrixElemAt(X, Y, Board, Piece),
  Piece \= 'emptyCell',
  X1 is X+1, X2 is X+2, Y1 is Y-1, Y2 is Y-2,
  getMatrixElemAt(X1, Y1, Board, Elem2),
  getMatrixElemAt(X2, Y2, Board, Elem3),
  Piece == Elem2, Piece == Elem3
  ).

game_over(Board, Winner) :-(
  checkVertical(Board, Piece) ;
  checkHorizontal(Board, Piece) ;
  checkDiagonal(Board, Piece)), (
  Piece == 'blackPiece' -> Winner = 'blackPlayer' ;
  (Piece == 'whitePiece' -> Winner = 'whitePlayer' ; false)).
