%========================%
%= @@ console utilities =%
%========================%

clear_console:-
	clear_console(40), !.

clear_console(0).
clear_console(N):-
	nl,
	N1 is N-1,
	clear_console(N1).

waitForEnter:-
  get_char(_).

print_enter_to_continue:-
	write('Press <Enter> to continue.'), nl,
	waitForEnter, !.

discard_input_char:-
  get_code(_).

%TODO: improve this to get character before "Enter"
%Trap char in Input variable, discard "Enter"
getChar(Input):-
  get_char(Input),
  get_char(_).

%in ascii: ascii_code(1)-48 = 1.
get_int(Input):-
	get_code(TempInput),
	Input is TempInput - 48.

get_move_int(Input):-
	read(TempInput),
	(integer(TempInput) -> Input = TempInput; fail).
