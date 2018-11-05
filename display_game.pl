%===============================%
%= @@ board printing functions =%
%===============================%

write_letters:-write('       A       B       C       D       E').
write_spaces:-write('   |       |       |       |       |       |').
write_line:-write('   -----------------------------------------').

get_cell_symbol(emptyCell, ' ').
get_cell_symbol(whitePiece, 'O').
get_cell_symbol(blackPiece, '#').
get_cell_symbol(_, '?').

get_player_name(whitePlayer, 'White').
get_player_name(blackPlayer, 'Black').

print_turn_info(Player):-
  get_player_name(Player, PlayerName),
  write('# It is '), write(PlayerName), write(' player\'s turn to play.'), nl.

display_game(Board, Player):-
  display_board(Board, 0),
  write_line, nl,
  write_letters,nl,
  print_turn_info(Player).

display_board([],_).
display_board([Line|Tail], Y):-
  write_line, nl,
  write_spaces, nl,
  Y1 is Y+1,
  display_line(Line, Y1), nl,
  write_spaces, nl,
  display_board(Tail, Y1).

display_line(Line, Y):-
  write(Y), write('  |'),
  display_line_aux(Line).

display_line_aux([]).
display_line_aux([Cell|Tail]):-
  get_cell_symbol(Cell,Symbol),
  write('   '), write(Symbol), write('   |'),
  display_line_aux(Tail).
