configure_pvp_game:-
  initial_board(Board),
  set_game_board(Board),
  set_game_mode(pvp),
  set_game_turn(blackPlayer).

configure_pvb_game:-
  initial_board(Board),
  set_game_board(Board),
  set_game_mode(pvb),
  set_game_turn(blackPlayer).

configure_bvp_game:-
  initial_board(Board),
  set_game_board(Board),
  set_game_mode(bvp),
  set_game_turn(blackPlayer).

configure_bvb_game:-
  initial_board(Board),
  set_game_board(Board),
  set_game_mode(bvb),
  set_game_turn(blackPlayer).

%========================%
%=       @@setters      =%
%========================%

set_game_board(Board):-
  nonvar(Board),
  retract(game_board(_)),
  asserta(game_board(Board)).

set_game_mode(Mode):-
  nonvar(Mode),
  retract(game_mode(_)),
  asserta(game_mode(Mode)).

set_game_turn(Player):-
  nonvar(Player),
  retract(game_turn(_)),
  asserta(game_turn(Player)).

set_bot_diff(Level):-
  nonvar(Level),
  retract(bot_diff(_)),
  asserta(bot_diff(Level)).
%====================%
%= @@ board presets =%
%====================%

initial_board([
  [emptyCell,whitePiece,emptyCell,whitePiece,emptyCell],
  [emptyCell,emptyCell,blackPiece,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,whitePiece,emptyCell,emptyCell],
  [emptyCell,blackPiece,emptyCell,blackPiece,emptyCell]
  ]).

%test_board_1 state expected value - 500
test_board_1([
  [whitePiece,whitePiece,emptyCell,emptyCell,blackPiece],
  [blackPiece,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,whitePiece,emptyCell,emptyCell,emptyCell]
  ]).


%test_board_2 state expected value - 0
test_board_2([
  [whitePiece,whitePiece,blackPiece,emptyCell,blackPiece],
  [whitePiece,emptyCell,emptyCell,emptyCell,blackPiece],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell]
  ]).

%test_board_3 state expected value - 500
test_board_3([
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [whitePiece,emptyCell,emptyCell,emptyCell,blackPiece],
  [whitePiece,whitePiece,emptyCell,emptyCell,blackPiece]
  ]).

white_win_board([
  [emptyCell,whitePiece,whitePiece,whitePiece,emptyCell],
  [emptyCell,emptyCell,blackPiece,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,blackPiece,emptyCell,blackPiece,emptyCell]
  ]).

black_win_board([
  [emptyCell,whitePiece,emptyCell,whitePiece,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
  [whitePiece,emptyCell,emptyCell,emptyCell,emptyCell],
  [emptyCell,blackPiece,blackPiece,blackPiece,emptyCell]
  ]).
