% Menus
% 50 columns so to center text use the 25th column

main_menu:-
  repeat,

  print_main_menu,
  read_option(1, Option), !,
  (
    Option = 1 -> game_mode_menu, main_menu;
    Option = 2 -> print_help, main_menu;
    Option = 3 -> print_about, main_menu;
    Option = 4;

    nl,
    write('Error: invalid option.'), nl,
    print_enter_to_continue, nl,
    main_menu
  ).

print_main_menu:-
  clear_console,
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

start_pvp_game:-
  configure_pvp_game,
  play_game.

start_pvb_game:-
  configure_pvb_game,
  play_game.

start_bvp_game:-
  configure_bvp_game,
  play_game.

start_bvb_game:-
  configure_bvb_game,
  play_game.

game_mode_menu:-
  repeat,

  print_game_mode_menu,
  read_option(1, Option), !,
  (
		Option = 1 -> start_pvp_game;
  	Option = 2 -> start_pvb_game;
    Option = 3 -> start_bvp_game;
	  Option = 4 -> start_bvb_game;
	  Option = 5 -> difficulty_menu;
    Option = 6;

    nl,
		write('Error: invalid option.'), nl,
		print_enter_to_continue, nl,
		game_mode_menu
  ).

print_game_mode_menu:-
  clear_console,
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
  write('=  2. Player vs. Computer (Player goes first)       ='),nl,
  write('=  3. Computer vs. Player (Computer goes first)     ='),nl,
  write('=  4. Computer vs. Computer                        ='),nl,
  write('=  5. Set Computer Difficulty                       ='),nl,
  write('=  6. Back                                         ='),nl,
  write('=                                                  ='),nl,
  write('===================================================='),nl,
  write('Choose an option: '),nl.

difficulty_menu:-
  repeat,

  print_difficulty_menu,
  read_option(1, Option), !,
  (
    Option = 1 -> set_bot_diff(random), game_mode_menu;
    Option = 2 -> set_bot_diff(greedy), game_mode_menu;
    Option = 3;

    nl,
		write('Error: invalid option.'), nl,
		print_enter_to_continue, nl,
		difficulty_menu
  ).

print_difficulty_menu:-
  clear_console,
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
  write('=  1. Random                                       ='),nl,
  write('=  2. Greedy                                       ='),nl,
  write('=  3. Back                                         ='),nl,
  write('=                                                  ='),nl,
  write('===================================================='),nl,
  write('Choose an option: '),nl.

print_about:-
  clear_console,
  write('===================================================='),nl,
  write('=                  ..:: About ::..                 ='),nl,
  write('===================================================='),nl,
  write('=                                                  ='),nl,
  write('=  Neutreeko is played on a 5x5 board.             ='),nl,
  write('=  There are two players: Black and White.         ='),nl,
  write('=                                                  ='),nl,
  write('=  Neutreeko is a highly tactical game with        ='),nl,
  write('=  little room for long-term strategic planning.   ='),nl,
  write('=                                                  ='),nl,
  write('=  But if neither side has an attack coming up,    ='),nl,
  write('=  it can often be a good idea to immobilize       ='),nl,
  write('=  your opponent by forcing him into a corner.     ='),nl,
  write('=                                                  ='),nl,
  write('=                                              1/2 ='),nl,
  write('===================================================='),nl,
	print_enter_to_continue, nl,

  clear_console,
  write('===================================================='),nl,
  write('=                  ..:: About ::..                 ='),nl,
  write('===================================================='),nl,
  write('=                                                  ='),nl,
  write('=  The name is a portmanteau of Neutron and Teeko, ='),nl,
  write('=  two games on which it is based.                 ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=  Bernardo Manuel Costa Barbosa - up201503477     ='),nl,
  write('=  Joao Pedro Teixeira Pereira de Sa - up201506252 ='),nl,
  write('=                                                  ='),nl,
  write('=  Programacao em Logica                           ='),nl,
  write('=  Faculdade de Engenharia                         ='),nl,
  write('=  Universidade do Porto  2018/2019                ='),nl,
  write('=                                              2/2 ='),nl,
  write('===================================================='),nl,
  print_enter_to_continue, nl.


print_help:-
  clear_console,
  write('===================================================='),nl,
  write('=               ..:: How To Play ::..              ='),nl,
  write('===================================================='),nl,
  write('=                                                  ='),nl,
  write('=  The goal of Neutreeko is to place three of      ='),nl,
  write('=  your own checkers in a row, orthogonally or     ='),nl,
  write('=  diagonally.                                     ='),nl,
  write('=                                                  ='),nl,
  write('=  Players move alternately one checker per turn,  ='),nl,
  write('=  starting with the player controlling the        ='),nl,
  write('=  black checkers.                                 ='),nl,
  write('=                                                  ='),nl,
  write('=  A checker slides orthogonally or diagonally     ='),nl,
  write('=  until stopped by an occupied cell or the edge   ='),nl,
  write('=                                              1/2 ='),nl,
  write('===================================================='),nl,
	print_enter_to_continue, nl,

  clear_console,
  write('===================================================='),nl,
  write('=               ..:: How To Play ::..              ='),nl,
  write('===================================================='),nl,
  write('=                                                  ='),nl,
  write('=  of the board.                                   ='),nl,
  write('=                                                  ='),nl,
  write('=  The game is declared a draw if the same         ='),nl,
  write('=  position occurs three times.                    ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                                  ='),nl,
  write('=                                              2/2 ='),nl,
  write('===================================================='),nl,
  print_enter_to_continue, nl.
