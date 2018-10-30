%min max with alpha beta pruning
piece_value(emptyCell, 0).
piece_value(whitePiece, 1).
piece_value(blackPiece, -1).

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
value(Board, Player, Value):-
  evaluate_board(Board, Value, 0).

evaluate_board(Board, 0, Iterator):-
  Iterator>4.

evaluate_board(Board, Value, Iterator):-
  Iterator>=5;
  nth0(Iterator, Board, Line), !,
  evaluate_line(Line, LineValue, Iterator, 0),
  IteratorNext is Iterator+1,
  evaluate_board(Board, RemainingValue, IteratorNext),
  Value is LineValue+RemainingValue.

evaluate_line(Line, 0, _, Column):-
  Column>4.

evaluate_line(Line, LineValue, Row, Column):-
  Column>=5;
  nth0(Column, Line, Piece), !,
  piece_value(Piece, PieceValue),
  board_weight(Row, Column, Weight),
  ColumnNext is Column+1,
  evaluate_line(Line, RemainingValue, Row, ColumnNext),
  LineValue is PieceValue*Weight + RemainingValue.
