%utilities

clear_console:-
	clear_console(40), !.

clear_console(0).
clear_console(N):-
	nl,
	N1 is N-1,
	clear_console(N1).

%TODO: improve this to get character before "Enter"
%Trap char in Input variable, discard "Enter"
getChar(Input):-
  get_char(Input),
  get_char(_).

getInt(Input):-
	get_code(TempInput),
	Input is TempInput - 48.

pressEnterToContinue:-
	write('Press <Enter> to continue.'), nl,
	waitForEnter, !.

waitForEnter:-
	get_char(_).
