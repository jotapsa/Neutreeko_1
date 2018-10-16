%utilities

clearConsole:-
	clearConsole(40), !.

clearConsole(0).
clearConsole(N):-
	nl,
	N1 is N-1,
	clearConsole(N1).

%TODO: improve this to get character before "Enter"
%Trap char in Input variable, discard "Enter"
getChar(Input):-
  get_char(Input),
  get_char(_).

pressEnterToContinue:-
	write('Press <Enter> to continue.'), nl,
	waitForEnter, !.

waitForEnter:-
	get_char(_).


% for display

printLetters:-write('     A     B     C     D     E').
printSpaces:-write('   |    |     |     |     |     |').
printLine:-write('   ------------------------------').
