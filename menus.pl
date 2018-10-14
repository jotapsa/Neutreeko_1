% Menus
% 50 columns so to center text use the 25th column

mainMenu:-
  printMainMenu,
  getChar(Input),
  (
    Input = '1' -> gameModeMenu, mainMenu;
    Input = '2' -> printHelp, mainMenu;
    Input = '3' -> printAbout, mainMenu;
    Input = '4';

    nl,
    write('Error: invalid input.'), nl,
    pressEnterToContinue, nl,
    mainMenu
  ).

%TODO: Center printMainMenu & fix other menus

printMainMenu:-
  clearConsole,
  write('===================================================='),nl,
  write('=                  ..:: Menu ::..                  ='),nl,
  write('===================================================='),nl,
  write('=                    _                 _           ='),nl,
  write('=                   | |               | |          ='),nl,
  write('=   _ __   ___ _   _| |_ _ __ ___  ___| | _____    ='),nl,
  write('=  | \'_ \\ / _ \\ | | | __| \'__/ _ \\/ _ \\ |/ / _ \\   ='),nl,
  write('=  | | | |  __/ |_| | |_| | |  __/  __/   < (_) |  ='),nl,
  write('=  |_| |_|\\___|\\__,_|\\__|_|  \\___|\\___|_|\\_\\___/   ='),nl,
  write('=                                                  ='),nl,
  write('=  1.Play                                          ='),nl,
  write('=  2.How to Play                                   ='),nl,
  write('=  3.About                                         ='),nl,
  write('=  4.Exit                                          ='),nl,
  write('=                                                  ='),nl,
  write('===================================================='),nl,
  write('Choose an option: '),nl.


gameModeMenu:-
  printgameModeMenu,
  getChar(Input),
  (
		Input = '1' -> startPvPGame;
  	% Input = '2' -> startPvBGame;
	  % Input = '3' -> startBvBGame;
	  Input = '4' -> difficultyMenu;
    Input = '5';

    nl,
		write('Error: invalid input.'), nl,
		pressEnterToContinue, nl,
		gameModeMenu
  ).

printgameModeMenu:-
  clearConsole,
  write('===================================================='),nl,
  write('=                ..:: Game Mode ::..               ='),nl,
  write('===================================================='),nl,
  write('=                    _                 _           ='),nl,
  write('=                   | |               | |          ='),nl,
  write('=   _ __   ___ _   _| |_ _ __ ___  ___| | _____    ='),nl,
  write('=  | \'_ \\ / _ \\ | | | __| \'__/ _ \\/ _ \\ |/ / _ \\   ='),nl,
  write('=  | | | |  __/ |_| | |_| | |  __/  __/   < (_) |  ='),nl,
  write('=  |_| |_|\\___|\\__,_|\\__|_|  \\___|\\___|_|\\_\\___/   ='),nl,
  write('=                                                  ='),nl,
  write('=  1. Player vs. Player                            ='),nl,
  write('=  2. Player vs. Computer                          ='),nl,
  write('=  3. Computer vs. Computer                        ='),nl,
  write('=  4. Set Computer Difficulty                      ='),nl,
  write('=  5. Back                                         ='),nl,
  write('=                                                  ='),nl,
  write('===================================================='),nl,
  write('Choose an option: '),nl.

startPvPGame:-
	createPvPGame(Game),
	playGame(Game).
startPvBGame:-
	createPvBGame(Game),
	playGame(Game).
startBvBGame:-
	createBvBGame(Game),
	playGame(Game).

difficultyMenu:-
  printdifficultyMenu,
  getChar(Input),
  (
    % Input = '1' -> setBotDifficulty(1), gameModeMenu;
    % Input = '2' -> setBotDifficulty(2), gameModeMenu;
    % Input = '3' -> setBotDifficulty(3), gameModeMenu;
    Input = '4';

    nl,
		write('Error: invalid input.'), nl,
		pressEnterToContinue, nl,
		difficultyMenu
  ).

printdifficultyMenu:-
  clearConsole,
  write('===================================================='),nl,
  write('=           ..:: Computer Difficulty ::..          ='),nl,
  write('===================================================='),nl,
  write('=                    _                 _           ='),nl,
  write('=                   | |               | |          ='),nl,
  write('=   _ __   ___ _   _| |_ _ __ ___  ___| | _____    ='),nl,
  write('=  | \'_ \\ / _ \\ | | | __| \'__/ _ \\/ _ \\ |/ / _ \\   ='),nl,
  write('=  | | | |  __/ |_| | |_| | |  __/  __/   < (_) |  ='),nl,
  write('=  |_| |_|\\___|\\__,_|\\__|_|  \\___|\\___|_|\\_\\___/   ='),nl,
  write('=                                                  ='),nl,
  write('=  1. Easy                                         ='),nl,
  write('=  2. Medium                                       ='),nl,
  write('=  3. Hard                                         ='),nl,
  write('=  4. Back                                         ='),nl,
  write('=                                                  ='),nl,
  write('===================================================='),nl,
  write('Choose an option: '),nl.

printAbout:-
  clearConsole,
  write('===================================================='),nl,
  write('=                  ..:: About ::..                 ='),nl,
  write('===================================================='),nl,
  write('=                                                  ='),nl,
  write('=  Neutreeko is played on a 5x5 board.             ='),nl,
  write('=  There are two players: Black and White.         ='),nl,
  write('=                                                  ='),nl,
  write('=  The goal of Neutreeko is to place three of      ='),nl,
  write('=  your own checkers in a row, orthogonally or     ='),nl,
  write('=  diagonally.                                     ='),nl,
  write('=                                                  ='),nl,
  write('=  Neutreeko is a highly tactical game with        ='),nl,
  write('=  little room for long-term strategic planning.   ='),nl,
  write('=                                                  ='),nl,
  write('=                                      Page 1 of 2 ='),nl,
  write('===================================================='),nl,
	pressEnterToContinue, nl,

  clearConsole,
  write('===================================================='),nl,
  write('=                  ..:: About ::..                 ='),nl,
  write('===================================================='),nl,
  write('=                                                  ='),nl,
  write('=  But if neither side has an attack coming up,    ='),nl,
  write('=  it can often be a good idea to immobilize       ='),nl,
  write('=  your opponent by forcing him into a corner.     ='),nl,
  write('=                                                  ='),nl,
  write('=  The name is a portmanteau of Neutron and Teeko, ='),nl,
  write('=  two games on which it is based.                 ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                      Page 2 of 2 ='),nl,
  write('===================================================='),nl,
  pressEnterToContinue, nl.


printHelp:-
  clearConsole,
  write('===================================================='),nl,
  write('=               ..:: How To Play ::..              ='),nl,
  write('===================================================='),nl,
  write('=                                                  ='),nl,
  write('=  Players move alternately one checker per turn,  ='),nl,
  write('=  starting with the player controlling the        ='),nl,
  write('=  black checkers.                                 ='),nl,
  write('=                                                  ='),nl,
  write('=  A checker slides orthogonally or diagonally     ='),nl,
  write('=  until stopped by an occupied cell or the edge   ='),nl,
  write('=  of the board.                                   ='),nl,
  write('=                                                  ='),nl,
  write('=  The game is declared a draw if the same         ='),nl,
  write('=  position occurs three times.                    ='),nl,
  write('=                                      Page 1 of x ='),nl,
  write('===================================================='),nl,
	pressEnterToContinue, nl,

  clearConsole,
  write('===================================================='),nl,
  write('=               ..:: How To Play ::..              ='),nl,
  write('===================================================='),nl,
  write('=                                                  ='),nl,
  write('=  Text starts here                                ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                      Page 2 of x ='),nl,
  write('===================================================='),nl,
  pressEnterToContinue, nl.
