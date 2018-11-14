:-use_module(library(lists)).
:-use_module(library(random)).
:-use_module(library(aggregate)).
:-use_module(library(between)).
:-use_module(library(system)).

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

next_turn(whitePlayer, blackPlayer).
next_turn(blackPlayer, whitePlayer).

:-dynamic game_board/1.
game_board([
  [emptyCell,whitePiece,emptyCell,whitePiece,emptyCell],
  [emptyCell,emptyCell,blackPiece,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,whitePiece,emptyCell,emptyCell],
  [emptyCell,blackPiece,emptyCell,blackPiece,emptyCell]
  ]).

:-dynamic game_turn/1.
game_turn(blackPlayer).

:-dynamic bot_diff/1.
bot_diff(random).

%p = player, b = bot
:-dynamic game_mode/1.
game_mode(pvp).

play_game:-
  game_board(Board),
  game_over(Board, Winner), !,
  display_game(Board),
  announce(Winner).

play_game:-
  game_mode(Mode),
  Mode == pvp,
  game_board(Board), game_turn(CurrentTurn),

  human_play(Board, CurrentTurn, ResultantBoard),
  set_game_board(ResultantBoard),
  next_turn(CurrentTurn, NextTurn),
  set_game_turn(NextTurn),
  play_game, !.

play_game:-
  game_mode(Mode),
  Mode == pvb,
  game_board(Board), game_turn(CurrentTurn),
  (
    (CurrentTurn == blackPlayer,
    human_play(Board, CurrentTurn, ResultantBoard),
    set_game_board(ResultantBoard),
    next_turn(CurrentTurn, NextTurn),
    set_game_turn(NextTurn), !,
    play_game, !
    );
    (CurrentTurn == whitePlayer,
    bot_play(Board, CurrentTurn, ResultantBoard),
    set_game_board(ResultantBoard),
    next_turn(CurrentTurn, NextTurn),
    set_game_turn(NextTurn), !,
    play_game, !
    )
  ).

  play_game:-
    game_mode(Mode),
    Mode == bvp,
    game_board(Board), game_turn(CurrentTurn),
    (
      (CurrentTurn == whitePlayer,
      human_play(Board, CurrentTurn, ResultantBoard),
      set_game_board(ResultantBoard),
      next_turn(CurrentTurn, NextTurn),
      set_game_turn(NextTurn), !,
      play_game, !
      );
      (CurrentTurn == blackPlayer,
      bot_play(Board, CurrentTurn, ResultantBoard),
      set_game_board(ResultantBoard),
      next_turn(CurrentTurn, NextTurn),
      set_game_turn(NextTurn), !,
      play_game, !
      )
    ).

play_game:-
  game_mode(Mode),
  Mode == bvb,

  game_board(Board),
  game_turn(CurrentTurn),
  display_game(Board, CurrentTurn),
  sleep(1),
  bot_play(Board, CurrentTurn, ResultantBoard),
  set_game_board(ResultantBoard),
  next_turn(CurrentTurn, NextTurn),
  set_game_turn(NextTurn), !,
  play_game, !.

bot_play(Board, Player, ResultantBoard):-
  bot_diff(Level),
  choose_move(Board, Player, Level, Move),
  move(Move, Board, ResultantBoard).

human_play(Board, Player, ResultantBoard):-
  repeat,

  clear_console,
  display_game(Board,Player),
  valid_moves(Board, Player, ListOfMoves),
  display_moves(ListOfMoves, 1),
  get_move_index(Index),
  getListElemAt(Index, ListOfMoves, Move),
  move(Move, Board, ResultantBoard).

%
% human_play(Game, ResultantGame):-
%   get_game_board(Game, Board),
%   get_game_player_turn(Game, Player),
%
%   repeat,
%
%   clear_console,
%   display_game(Board, Player),
%   valid_moves(Board, Player, ListOfMoves),
%   display_moves(ListOfMoves, 1),
%   get_move_index(Index),
%   getListElemAt(Index, ListOfMoves, Move),
%   move(Move, Board, ResultantBoard),
%   set_game_board(ResultantBoard, Game, ResultantGame), !.

valid_moves(Board, Player, ListOfMoves):-
  get_player_piece(Player, Piece),
  findall(m(Yi, Xi, Y, X) , (
        getMatrixElemAt(Yi, Xi, Board, Piece),
        between(0, 4, Y), between(0, 4, X),
        validate_move(m(Yi, Xi, Y, X), Board)
      ), ListOfMoves).

%==============================================%
%= @@ board validation/manipulation functions =%
%==============================================%

validate_chosen_piece_ownership(m(Yi, Xi, _, _), Board, Player):-
	getMatrixElemAt(Yi, Xi, Board, Piece),
	piece_owner(Piece, Player), !.

validate_chosen_piece_ownership(m(_, _, _, _), _, _):-
	write('# INVALID PIECE!'), nl,
	write('# A player can only move his/her own pieces.'), nl,
	print_enter_to_continue, nl,
	fail.

validate_coordinates_different(m(Yi, Xi, Yf, Xf)):-
	(Yi \= Yf ; Xi \= Xf), !.

validate_coordinates_different(m(_, _, _, _)):-
	write('# INVALID INPUT!'), nl,
	write('# The source and destiny coordinates must be different.'), nl,
	print_enter_to_continue, nl,
	fail.

validate_move(m(Yi, Xi, Yf, Xf), Board):-
  validate_X_move(m(Yi, Xi, Yf, Xf), Board);
  validate_Y_move(m(Yi, Xi, Yf, Xf), Board);
  validate_XY_move(m(Yi, Xi, Yf, Xf), Board).

validate_X_move(m(Yi, Xi, Yf, Xf), Board):-
  DiffX is Xf - Xi,
  DiffY is Yf - Yi,
  DiffY == 0, DiffX \= 0,
  (DiffX > 0 -> Direction is 1 ; Direction is -1),
  validate_X_move_aux(m(Yi, Xi, Yf, Xf), Board, Direction, 0).

validate_X_move_aux(m(Yi, Xi, Yf, Xf), Board, Direction, CurrIndex):-
  NewIndex is CurrIndex+Direction,
  NextX is Xi+NewIndex,

  getMatrixElemAt(Yi, NextX, Board, NextElem),
  (
    NextElem == 'emptyCell' -> (NextX == Xf ->
                                  (AfterX is NextX+Direction,
                                    getMatrixElemAt(Yi, AfterX , Board, NextElem) ->
                                      (NextElem == 'emptyCell' -> false ; true) ; true
                                  )
                                 ; validate_X_move_aux(m(Yi, Xi, Yf, Xf), Board, Direction, NewIndex)
                               ) ; false
  ).

validate_Y_move(m(Yi, Xi, Yf, Xf), Board):-
  DiffX is Xf - Xi,
  DiffY is Yf - Yi,
  DiffY \= 0, DiffX == 0,
  (DiffY > 0 -> Direction is 1 ; Direction is -1),
  validate_Y_move_aux(m(Yi, Xi, Yf, Xf), Board, Direction, 0).

validate_Y_move_aux(m(Yi, Xi, Yf, Xf), Board, Direction, CurrIndex):-
  NewIndex is CurrIndex+Direction,
  NextY is Yi+NewIndex,

  getMatrixElemAt(NextY, Xi, Board, NextElem),
  (
    NextElem == 'emptyCell' -> (NextY == Yf ->
                                  (AfterY is NextY+Direction,
                                    getMatrixElemAt(AfterY, Xf , Board, NextElem) ->
                                      (NextElem == 'emptyCell' -> false ; true) ; true
                                  )
                                 ; validate_Y_move_aux(m(Yi, Xi, Yf, Xf), Board, Direction, NewIndex)
                               ) ; false
  ).

validate_XY_move(m(Yi, Xi, Yf, Xf), Board):-
  DiffX is Xf - Xi,
  DiffY is Yf - Yi,
  DiffY \= 0, DiffX \= 0,
  DiffYAbs is abs(DiffY), DiffXAbs is abs(DiffX),
  DiffYAbs == DiffXAbs,
  (DiffY > 0 -> DirectionY is 1 ; DirectionY is -1),
  (DiffX > 0 -> DirectionX is 1 ; DirectionX is -1),
  validate_XY_move_aux(m(Yi, Xi, Yf, Xf), Board, DirectionY, DirectionX, 0,0).

validate_XY_move_aux(m(Yi, Xi, Yf, Xf), Board, DirectionY, DirectionX, CurrIndexY, CurrIndexX):-
  NewIndexY is CurrIndexY+DirectionY,
  NextY is Yi+NewIndexY,

  NewIndexX is CurrIndexX+DirectionX,
  NextX is Xi+NewIndexX,

  getMatrixElemAt(NextY, NextX, Board, NextElem),
  (
    NextElem == 'emptyCell' -> ( (NextY == Yf, NextX == Xf) ->
                                  (AfterY is NextY+DirectionY,
                                   AfterX is NextX+DirectionX,
                                    getMatrixElemAt(AfterY, AfterX, Board, NextElem) ->
                                      (NextElem == 'emptyCell' -> false ; true) ; true
                                  )
                                 ; validate_XY_move_aux(m(Yi, Xi, Yf, Xf), Board, DirectionY, DirectionX, NewIndexY, NewIndexX)
                               ) ; false
  ).


move(m(Yi, Xi, Yf, Xf), Board, ResultantBoard):-
  getMatrixElemAt(Yi, Xi, Board, SrcElem),
  setMatrixElemAtWith(Yi, Xi, emptyCell, Board, TempBoard),
  setMatrixElemAtWith(Yf, Xf, SrcElem, TempBoard, ResultantBoard).

% next_turn(Game, ResultantGame):-
%   get_game_player_turn(Game, Player),
%   (
%     Player == whitePlayer -> NextPlayer = blackPlayer;
%     NextPlayer = whitePlayer
%   ),
%   set_game_player_turn(NextPlayer, Game, ResultantGame).

%===========================%
%= @@ game input functions =%
%===========================%

get_move_index(Index):-
	write('Please insert the move you wish to do and press <Enter> - example: 1.'), nl,
  get_move_int(MoveIndex),
  Index is MoveIndex-1,nl.

get_piece_source_coords(m(Yi, Xi, _, _)):-
	write('Please insert the coordinates of the piece you wish to move and press <Enter> - example: 3f.'), nl,
	input_coords(Yi, Xi), nl.

get_piece_destiny_coords(m(_, _, Yf, Xf)):-
  write('Please insert the destiny coordinates that piece and press <Enter>'), nl,
  input_coords(Yf, Xf), nl.

input_coords(Y, X):-
	get_int(RawSrcLine),
	get_code(RawSrcColumn),

	discard_input_char,

	% process row and column
	Y is RawSrcLine-1,
	X is RawSrcColumn-48-48-1.

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
