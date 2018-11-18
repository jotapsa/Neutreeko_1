%===============================%
%= @@ Neutreeko Game           =%
%===============================%

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

% Play. (start)
play:-
  main_menu.

play_game:-
  game_tie, !,
  announce_tie;
  game_winner(Winner) !,
  game_board(Board),
  display_game(Board),
  announce(Winner).

% Player vs Player game logic.
play_game:-
  game_mode(Mode),
  Mode == pvp,
  game_board(Board), game_turn(CurrentTurn),
  human_play(Board, CurrentTurn, ResultantBoard),
  set_game_board(ResultantBoard),
  add_game_board_history(ResultantBoard),
  next_turn(CurrentTurn, NextTurn),
  set_game_turn(NextTurn),
  play_game, !.

% Player vs Computer game logic.
play_game:-
  game_mode(Mode),
  Mode == pvb,
  game_board(Board), game_turn(CurrentTurn),
  (
    (CurrentTurn == blackPlayer,
    human_play(Board, CurrentTurn, ResultantBoard),
    set_game_board(ResultantBoard),
    add_game_board_history(ResultantBoard),
    next_turn(CurrentTurn, NextTurn),
    set_game_turn(NextTurn), !,
    play_game, !
    );
    (CurrentTurn == whitePlayer,
    bot_play(Board, CurrentTurn, ResultantBoard),
    set_game_board(ResultantBoard),
    add_game_board_history(ResultantBoard),
    next_turn(CurrentTurn, NextTurn),
    set_game_turn(NextTurn), !,
    play_game, !
    )
  ).

% Computer vs Player game logic.
play_game:-
  game_mode(Mode),
  Mode == bvp,
  game_board(Board), game_turn(CurrentTurn),
  (
    (CurrentTurn == whitePlayer,
    human_play(Board, CurrentTurn, ResultantBoard),
    set_game_board(ResultantBoard),
    add_game_board_history(ResultantBoard),
    next_turn(CurrentTurn, NextTurn),
    set_game_turn(NextTurn), !,
    play_game, !
    );
    (CurrentTurn == blackPlayer,
    bot_play(Board, CurrentTurn, ResultantBoard),
    set_game_board(ResultantBoard),
    add_game_board_history(ResultantBoard),
    next_turn(CurrentTurn, NextTurn),
    set_game_turn(NextTurn), !,
    play_game, !
    )
  ).

% Computer vs Computer game logic.
play_game:-
  game_mode(Mode),
  Mode == bvb,

  game_board(Board),
  game_turn(CurrentTurn),
  display_game(Board, CurrentTurn),
  sleep(1),
  bot_play(Board, CurrentTurn, ResultantBoard),
  set_game_board(ResultantBoard),
  add_game_board_history(ResultantBoard),
  next_turn(CurrentTurn, NextTurn),
  set_game_turn(NextTurn), !,
  play_game, !.

% Computer's movement.
% bot_play(+Board, +Player, -ResultantBoard)
bot_play(Board, Player, ResultantBoard):-
  bot_diff(Level),
  choose_move(Board, Player, Level, Move),
  move(Move, Board, ResultantBoard).

% PLlayer's movement.
% human_play(+Board, +Player, -ResultantBoard)
human_play(Board, Player, ResultantBoard):-
  repeat,

  clear_console,
  display_game(Board,Player),
  valid_moves(Board, Player, ListOfMoves),
  display_moves(ListOfMoves, 1),
  get_move_option(ListOfMoves, Option),
  getListElemAt(Option, ListOfMoves, Move),
  move(Move, Board, ResultantBoard).

% Function that gets all player's valid movements.
% valid_moves(+Board, +Player, -ListOfMoves)
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

% Function that validates a move.
% validate_move(+Move, +Board)
validate_move(m(Yi, Xi, Yf, Xf), Board):-
  validate_X_move(m(Yi, Xi, Yf, Xf), Board);
  validate_Y_move(m(Yi, Xi, Yf, Xf), Board);
  validate_XY_move(m(Yi, Xi, Yf, Xf), Board).

% Functions that validates a horizontal move.
% validate_X_move(+Move, +Board)
validate_X_move(m(Yi, Xi, Yf, Xf), Board):-
  DiffX is Xf - Xi,
  DiffY is Yf - Yi,
  DiffY == 0, DiffX \= 0,
  (DiffX > 0 -> Direction is 1 ; Direction is -1),
  validate_X_move_aux(m(Yi, Xi, Yf, Xf), Board, Direction, 0).

% validate_X_move_aux(+Move, +Board, +Direction, +CurrIndex)
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

% Functions that validates a vertical move.
% validate_Y_move(+Move, +Board)
validate_Y_move(m(Yi, Xi, Yf, Xf), Board):-
  DiffX is Xf - Xi,
  DiffY is Yf - Yi,
  DiffY \= 0, DiffX == 0,
  (DiffY > 0 -> Direction is 1 ; Direction is -1),
  validate_Y_move_aux(m(Yi, Xi, Yf, Xf), Board, Direction, 0).

% validate_Y_move_aux(+Move, +Board, +Direction, +CurrIndex)
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

% Functions that validates a diagonal move.
% validate_XY_move(+Move, +Board)
validate_XY_move(m(Yi, Xi, Yf, Xf), Board):-
  DiffX is Xf - Xi,
  DiffY is Yf - Yi,
  DiffY \= 0, DiffX \= 0,
  DiffYAbs is abs(DiffY), DiffXAbs is abs(DiffX),
  DiffYAbs == DiffXAbs,
  (DiffY > 0 -> DirectionY is 1 ; DirectionY is -1),
  (DiffX > 0 -> DirectionX is 1 ; DirectionX is -1),
  validate_XY_move_aux(m(Yi, Xi, Yf, Xf), Board, DirectionY, DirectionX, 0,0).

% validate_X_move_aux(+Move, +Board, +DirectionY, +DirectionX, +CurrIndexY, +CurrIndexX)
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

% Function that makes a Player move on the Board.
% move(+Move, +Board, -ResultantBoard)
move(m(Yi, Xi, Yf, Xf), Board, ResultantBoard):-
  getMatrixElemAt(Yi, Xi, Board, SrcElem),
  setMatrixElemAtWith(Yi, Xi, emptyCell, Board, TempBoard),
  setMatrixElemAtWith(Yf, Xf, SrcElem, TempBoard, ResultantBoard).


game_tie:-
  game_board_history(BoardHistory),
  check_tie(BoardHistory, BoardHistory).

check_tie([Head|_], BoardHistory):-
  count(BoardHistory, Head, NOfOccur),
  NOfOccur >= 3.

check_tie([Head|Tail], BoardHistory):-
  count(BoardHistory, Head, NOfOccur),
  NOfOccur < 3,
  check_tie(Tail, BoardHistory).

game_winner(Winner):-
  game_board(Board),
  board_winner(Board, Winner).

% Function that checks if a board has a winner.
% board_winner(+Move, -Winner)
board_winner(Board, Winner) :-(
  checkVertical(Board, Piece) ;
  checkHorizontal(Board, Piece) ;
  checkDiagonal(Board, Piece)), (
  Piece == 'blackPiece' -> Winner = 'blackPlayer' ;
  (Piece == 'whitePiece' -> Winner = 'whitePlayer' ; false)).

% Function that checks if there are 3 consecutive pieces horizontally.
% checkHorizontal(+Move, +Piece)
checkHorizontal(Board, Piece) :-
  getMatrixElemAt(X, Y, Board, Piece),
  piece(Piece),
  Y1 is Y+1, Y2 is Y+2,
  getMatrixElemAt(X, Y1, Board, Elem2),
  getMatrixElemAt(X, Y2, Board, Elem3),
  Piece == Elem2, Piece == Elem3.

% Function that verifies that there are 3 consecutive pieces vertically.
% checkVertical(+Move, +Piece)
checkVertical(Board, Piece) :-
  getMatrixElemAt(X, Y, Board, Piece),
  piece(Piece),
  X1 is X+1, X2 is X+2,
  getMatrixElemAt(X1, Y, Board, Elem2),
  getMatrixElemAt(X2, Y, Board, Elem3),
  Piece == Elem2, Piece == Elem3.

% Function that checks if there are 3 consecutive pieces diagonally.
% checkDiagonal(+Move, +Piece)
checkDiagonal(Board, Piece) :-  (
  getMatrixElemAt(X, Y, Board, Piece),
  piece(Piece),
  X1 is X+1, X2 is X+2, Y1 is Y+1, Y2 is Y+2,
  getMatrixElemAt(X1, Y1, Board, Elem2),
  getMatrixElemAt(X2, Y2, Board, Elem3),
  Piece == Elem2, Piece == Elem3
  );
  (getMatrixElemAt(X, Y, Board, Piece),
  piece(Piece),
  X1 is X+1, X2 is X+2, Y1 is Y-1, Y2 is Y-2,
  getMatrixElemAt(X1, Y1, Board, Elem2),
  getMatrixElemAt(X2, Y2, Board, Elem3),
  Piece == Elem2, Piece == Elem3
  ).

%===========================%
%= @@ game input functions =%
%===========================%

% Function that reads user input move option.
% get_move_option(+ListOfMoves, -Option)
get_move_option(ListOfMoves, Option):-
	write('Choose a move:'), nl,
  length(ListOfMoves, ListOfMovesLength),
  MaxSizeOfOption is (ListOfMovesLength//10)+1,
  read_option(MaxSizeOfOption, MoveOption),
  Option is MoveOption-1.
