%========================%
%= @@ console utilities =%
%========================%

% Function that prints the winner.
announce(Winner):-
  (
    (
    Winner == whitePlayer, nl,
    write('White Player won!')
    );
    (
    Winner == blackPlayer, nl,
    write('Black Player won!')
    )
  ), waitForEnter.

% Function that cleans the console.
clear_console:-
	clear_console(40), !.

clear_console(0).
clear_console(N):-
	nl,
	N1 is N-1,
	clear_console(N1).

% Functions that waits for user to press Enter.
waitForEnter:-
  get_char(_).

print_enter_to_continue:-
	write('Press <Enter> to continue.'), nl,
	waitForEnter, !.

discard_input_char:-
  get_code(_).

announce_tie:-
  write('It\'s a tie!, the same positions have been repeated three times.').

count([],X,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- X1\=X,count(T,X,Z).

% Function that reads user input option.
read_option(MaxLength, Option):-
  read_line(Line),
  length(Line, LineLength),
  LineLength =< MaxLength,
  read_option_aux(Line, LineLength, FloatOption),
  Option is integer(FloatOption).

read_option_aux([], _, 0).
read_option_aux([Head|Tail], LineLength, Option):-
  Head >= 48, Head =<57, %verify if its a value between 0 and 9
  TailLenght is LineLength-1,
  read_option_aux(Tail, TailLenght, TailOption),
  Option is (Head-48)*exp(10,TailLenght)+TailOption.
