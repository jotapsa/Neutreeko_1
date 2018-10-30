%min max with alpha beta pruning

%board_weight(X, Y, Value)
board_weight(0,0,100).
board_weight(0,1,250).
board_weight(0,2,500).
board_weight(0,3,250).
board_weight(0,4,100).
board_weight(1,2,300).
board_weight(1,_,250).
board_weight(2,0,500).
board_weight(2,1,300).
board_weight(2,2,100).
board_weight(2,3,300).
board_weight(2,4,100).
board_weight(3,2,300).
board_weight(3,_,250).
board_weight(4,0,100).
board_weight(4,1,250).
board_weight(4,2,500).
board_weight(4,3,250).
board_weight(4,4,100).


%We need to somehow initialize Value at 0
value([], Player, Value).
value([Line|Tail], Player, Value):-
  evaluate_line_value(Line, Player, LiveValue),
  Value is Value + LineValue,

evaluate_line_value([], Player, LineValue).
evaluate_line_value([Column|Columns], Player, LineValue):-
