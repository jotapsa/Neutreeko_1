%===============================%
%= @@ board printing functions =%
%===============================%

% Write Board Letter Coordinates.
write_letters:-write('       A       B       C       D       E').

% Write Board Spaces.
write_spaces:-write('   |       |       |       |       |       |').

% Write Board Row.
write_line:-write('   -----------------------------------------').

% Get Board piece symbol.
get_cell_symbol(emptyCell, ' ').
get_cell_symbol(whitePiece, 'O').
get_cell_symbol(blackPiece, '#').
get_cell_symbol(_, '?').

% Get Player name.
get_player_name(whitePlayer, 'White').
get_player_name(blackPlayer, 'Black').

% Get Player piece.
get_player_piece(blackPlayer, blackPiece).
get_player_piece(whitePlayer, whitePiece).

% Get number coordinate from letter.
get_letter_coordinate(0, 'A').
get_letter_coordinate(1, 'B').
get_letter_coordinate(2, 'C').
get_letter_coordinate(3, 'D').
get_letter_coordinate(4, 'E').

% Function that prints the turn of the player who is playing.
% print_turn_info(+Player)
print_turn_info(Player):-
  get_player_name(Player, PlayerName),nl,
  write('# It is '), write(PlayerName), write(' player\'s turn to play.'), nl.

% Functions to print a Board.
% display_game(+Board)
display_game(Board):-
  display_board(Board, 0),
  write_line, nl,
  write_letters,nl, !.

% display_game(+Board, +Player)
display_game(Board, Player):-
  display_board(Board, 0),
  write_line, nl,
  write_letters,nl,
  print_turn_info(Player), !.

% display_game(+Board, +Y)
display_board([],_).
display_board([Line|Tail], Y):-
  write_line, nl,
  write_spaces, nl,
  Y1 is Y+1,
  display_line(Line, Y1), nl,
  write_spaces, nl,
  display_board(Tail, Y1).

% display_line(+Board, +Line)
display_line(Line, Y):-
  write(Y), write('  |'),
  display_line_aux(Line).

% display_line_aux(+List)
display_line_aux([]).
display_line_aux([Cell|Tail]):-
  get_cell_symbol(Cell,Symbol),
  write('   '), write(Symbol), write('   |'),
  display_line_aux(Tail).

% Function that prints all possible moves.
% display_moves(+ListOfMoves, +Index)
display_moves([],_).
display_moves([m(Yi, Xi, Yf, Xf)| Tail], X):-
write('   '), write(X), write(' | '),
YI is Yi+1, YF is Yf+1,
get_letter_coordinate(Xi, Si), write(Si), write(YI), write(' ---> '),
get_letter_coordinate(Xf, Sf), write(Sf), write(YF),nl,
X1 is X+1,
display_moves(Tail,X1).
