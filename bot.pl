%=================%
%= @@ alpha beta =%
%=================%

maximizing(whitePlayer).
minimizing(blackPlayer).

next_player(whitePlayer, blackPlayer).
next_player(blackPlayer, whitePlayer).

% alphabeta(Board, Depth, Move, Player):-
%   alphabeta(Board, Depth, Player, -1000, 1000, _, Move).
%
% alphabeta(Board, 0, Player, _, _, Value, _):-
%   value(Board, Value).
%
% alphabeta(Board, Depth, Player, Alpha, Beta, Value, Move):-
%   Depth>0,
%   Depth1 is Depth-1,
%   findall(M, move(Board, M), Moves),
%   alphabeta(Moves, Board, Depth1, Player, Alpha, Beta, BestMove, BestEval).
%
% alphabeta([Move|Moves], Board, Depth, Player, Alpha, Beta, BestMove, BestEval):-
%   move(Move, Board, ResultantBoard),
%   next_player(Player, NextPlayer),
%   alphabeta(ResultantBoard, Depth, _, Alpha, Beta, Value, NextPlayer),

%==================%
%= @@ value stuff =%
%==================%

%min maColIterator with alpha beta pruning
piece_value(emptyCell, 0).
piece_value(whitePiece, 1).
piece_value(blackPiece, -1).

%board_weight(ColIterator, RowIterator, Value)
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

value(Board, Value):-
  evaluate_board_pieces(Board, PiecesValue, 0),
  evaluate_board_state(Board, StateValue, 0),
  generate_random_component(RandomValue),
  evaluate_game_over(Board, GameOverValue),
  Value is PiecesValue + StateValue + RandomValue + GameOverValue.

evaluate_board_pieces(Board, 0, RowIterator):-
  RowIterator>4.

evaluate_board_pieces(Board, Value, RowIterator):-
  nth0(RowIterator, Board, Line), !,
  evaluate_line_pieces(Line, LineValue, RowIterator, 0),
  RowIteratorNext is RowIterator+1,
  evaluate_board_pieces(Board, RemainingValue, RowIteratorNext),
  Value is LineValue+RemainingValue.

evaluate_line_pieces(Line, 0, _, ColIterator):-
  ColIterator>4.

evaluate_line_pieces(Line, LineValue, RowIterator, ColIterator):-
  nth0(ColIterator, Line, Piece), !,
  piece_value(Piece, PieceValue),
  board_weight(RowIterator, Column, Weight),
  ColIteratorNext is ColIterator+1,
  evaluate_line_pieces(Line, RemainingValue, RowIterator, ColIteratorNext),
  LineValue is PieceValue*Weight + RemainingValue.

evaluate_board_state(Board, 0, RowIterator):-
  RowIterator>4.

evaluate_board_state(Board, Value, RowIterator):-
  !,
  evaluate_line_state(Board, LineValue, RowIterator, 0),
  RowIteratorNext is RowIterator+1,
  evaluate_board_state(Board, RemainingValue, RowIteratorNext),
  Value is LineValue+RemainingValue.

evaluate_line_state(Board, 0, _, ColIterator):-
  ColIterator>4.

evaluate_line_state(Board, LineValue, RowIterator, ColIterator):-
  !,
  RowAbove is RowIterator+1, RowBelow is RowIterator-1, RowAboveAbove is RowIterator+2, RowBelowBelow is RowIterator-2,
  ColAhead is ColIterator+1, ColBehind is ColIterator-1, ColAheadAhead is ColIterator+2, ColBehindBehind is ColIterator-2,
  %Check above
  ((getMatrixElemAt(RowIterator, ColIterator, Board, Piece1),
  getMatrixElemAt(RowAbove, ColIterator, Board, Piece2),
  (getMatrixElemAt(RowAboveAbove, ColIterator, Board, Piece3), Piece3 == emptyCell;
  getMatrixElemAt(RowBelowBelow, ColIterator, Board, Piece4), Piece4 == emptyCell),
  Piece1 \= emptyCell,
  Piece1 == Piece2)->
    piece_value(Piece1, PieceValue1), TempValue1 is PieceValue1 * 500;
    TempValue1 is 0
  ),
  %Check above right
  ((getMatrixElemAt(RowIterator, ColIterator, Board, Piece5),
  getMatrixElemAt(RowAbove, ColAhead, Board, Piece6),
  (getMatrixElemAt(RowAboveAbove, ColAheadAhead, Board, Piece7), Piece7 == emptyCell;
  getMatrixElemAt(RowBelow, ColBehind, Board, Piece8), Piece8 == emptyCell),
  Piece5 \= emptyCell,
  Piece5 == Piece6)->
    piece_value(Piece5, PieceValue2), TempValue2 is PieceValue2 * 500;
    TempValue2 is 0
  ),
  %Check right
  ((getMatrixElemAt(RowIterator, ColIterator, Board, Piece9),
  getMatrixElemAt(RowIterator, ColAhead, Board, Piece10),
  (getMatrixElemAt(RowIterator, ColAheadAhead, Board, Piece11), Piece11 == emptyCell;
  getMatrixElemAt(RowIterator, ColBehind, Board, Piece12), Piece12 == emptyCell),
  Piece9 \= emptyCell,
  Piece9 == Piece10)->
    piece_value(Piece9, PieceValue3), TempValue3 is PieceValue3 * 500;
    TempValue3 is 0
  ),
  %Check below right
  ((getMatrixElemAt(RowIterator, ColIterator, Board, Piece13),
  getMatrixElemAt(RowBelow, ColAhead, Board, Piece14),
  (getMatrixElemAt(RowBelowBelow, ColAheadAhead, Board, Piece15), Piece15 == emptyCell;
  getMatrixElemAt(RowAbove, ColBehind, Board, Piece16), Piece16 == emptyCell),
  Piece13 \= emptyCell,
  Piece13 == Piece14)->
    piece_value(Piece13, PieceValue4), TempValue4 is PieceValue4 * 500;
    TempValue4 is 0
  ),
  evaluate_line_state(Board, RemainingValue, RowIterator, ColAhead),
  LineValue is TempValue1 + TempValue2 + TempValue3 + TempValue4 + RemainingValue.

generate_random_component(RandomValue):-
  random(-10, 11, RandomValue).

evaluate_game_over(Board, GameOverValue):-
  (game_over(Board, Winner) ->(
    Winner == 'blackPlayer' -> piece_value(blackPiece, PieceValue), GameOverValue is PieceValue * 100000;
    Winner == 'whitePlayer' -> piece_value(whitePiece, PieceValue), GameOverValue is PieceValue * 100000
    );
    GameOverValue is 0
  ).
