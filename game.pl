%===============================%
%= @@ Game Structure           =%
%===============================%

% Board pieces.
piece(whitePiece).
piece(blackPiece).

% Board pieces owners.
piece_owner(whitePiece, whitePlayer).
piece_owner(blackPiece, blackPlayer).

% Get next turn after opponent's move.
next_turn(whitePlayer, blackPlayer).
next_turn(blackPlayer, whitePlayer).

% Dynamic game Board of Game.
:-dynamic game_board/1.
game_board([
[emptyCell,whitePiece,emptyCell,whitePiece,emptyCell],
[emptyCell,emptyCell,blackPiece,emptyCell,emptyCell],
[emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
[emptyCell,emptyCell,whitePiece,emptyCell,emptyCell],
[emptyCell,blackPiece,emptyCell,blackPiece,emptyCell]
]).

:-dynamic game_board_history/1.
game_board_history([
[emptyCell,whitePiece,emptyCell,whitePiece,emptyCell],
[emptyCell,emptyCell,blackPiece,emptyCell,emptyCell],
[emptyCell,emptyCell,emptyCell,emptyCell,emptyCell],
[emptyCell,emptyCell,whitePiece,emptyCell,emptyCell],
[emptyCell,blackPiece,emptyCell,blackPiece,emptyCell]
])

% Dynamic game Turn of Game.
:-dynamic game_turn/1.
game_turn(blackPlayer).

% Dynamic computer difficulty.
:-dynamic bot_diff/1.
bot_diff(greedy).

% Dynamic Game mode.
%p = player, b = bot
:-dynamic game_mode/1.
game_mode(pvp).

%===============================%
%= @@ Game Mode Configurations =%
%===============================%

% Configure Player vs Player game mode.
configure_pvp_game:-
  initial_board(Board),
  set_game_board(Board),
  set_game_board_history(Board),
  set_game_mode(pvp),
  set_game_turn(blackPlayer).

% Configure Player vs Computer game mode.
configure_pvb_game:-
  initial_board(Board),
  set_game_board(Board),
  set_game_board_history(Board),
  set_game_mode(pvb),
  set_game_turn(blackPlayer).

% Configure Computer vs Player game mode.
configure_bvp_game:-
  initial_board(Board),
  set_game_board(Board),
  set_game_board_history(Board),
  set_game_mode(bvp),
  set_game_turn(blackPlayer).

% Configure Computer vs Computer game mode.
configure_bvb_game:-
  initial_board(Board),
  set_game_board(Board),
  set_game_board_history(Board),
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

set_game_board_history(Board):-
  nonvar(Board),
  retractall(game_board_history(_)),
  asserta(game_board_history(Board)).

add_game_board_history(Board):-
  nonvar(Board),
  asserta(game_board(Board)).

%=================================%
%= @@ board presets and examples =%
%=================================%

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
