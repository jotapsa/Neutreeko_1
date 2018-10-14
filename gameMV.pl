% Game Model View


board([
[0,'branca',0,'branca',0],
[0,0,'preta',0,0],
[0,0,0,0,0],
[0,0,'branca',0,0],
[0,'preta',0,'preta',0]
]).

display_game(Board, Player) :- display_board(Board).

display_board([]).
display_board([L|T]):- display_line(L), nl,
                        display_board(T).

display_line([]).
display_line([C|L]) :- display_cell(C),
                        display_line(L).

display_cell([]).
display_cell(0) :- write('-').
display_cell('branca') :- write('B').
display_cell('preta') :- write('P').
