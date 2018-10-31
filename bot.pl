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


%We need to somehow initialize Value at 0
value(Board, Player, Value):-
  evaluate_board_pieces(Board, PiecesValue, 0),
  % evaluate_board_state(Board, StateValue, 0),
  generate_random_component(RandomValue),
  evaluate_game_over(Board, GameOverValue),
  % Value is PiecesValue + StateValue + RandomValue + GameOverValue.
  Value is PiecesValue + RandomValue + GameOverValue.

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

% evaluate_board_state(Board, 0, RowIterator):-
%   RowIterator>4.
%
% evaluate_board_state(Board, Value, RowIterator):-
%   nth0(RowIterator, Board, Line), !,
%   evaluate_line_state(Line, LineValue, RowIterator, 0),
%   RowIteratorNext is RowIterator+1,
%   evaluate_board_state(Board, RemainingValue, RowIteratorNext),
%   Value is LineValue+RemainingValue.
%
% evaluate_line_state(Line, 0, _, ColIterator):-
%   ColIterator>4.
%
% evaluate_line_state(Line, LineValue, RowIterator, ColIterator):-
%   RowAbove is RowIterator+1, RowBelow is RowIterator-1,
%   ColAbove is ColIterator+1, ColBelow is ColIterator-1,
%   if((nth0(RowIterator, Board, Line), nth0(ColIterator, Line, Piece1), nth0(SearchRow, Board, Line), nth0(SearchCol, Line, Piece2), Piece1 \= emptyCell, Piece1==Piece2),
%   (piece_value(Piece1, PieceValue), TempValue is TempValue + PieceValue * 5000),
%   TempValue is 1).
%
% evaluate_line_state(Line, LineValue, RowIterator, ColIterator):-
%   TempValue is 0,
%   (nth0(RowIterator, Board, Line), nth0(ColIterator, Line, Piece1), nth0(SearchRow, Board, Line), nth0(SearchCol, Line, Piece2), Piece1 \= emptyCell, Piece1==Piece2) ->(
%     piece_value(Piece1, PieceValue), TempValue is TempValue + PieceValue * 5000;
%     true
%   ),
%   SearchRow is RowIterator+1, SearchCol is ColIterator+1,
%   ((nth0(RowIterator, Board, Line), nth0(ColIterator, Line, Piece1), nth0(SearchRow, Board, Line), nth0(SearchCol, Line, Piece2), Piece1 \= emptyCell, Piece1==Piece2) ->(
%     piece_value(Piece1, PieceValue), TempValue is TempValue + PieceValue * 5000
%     )
%   ),
%   SearchRow is RowIterator, SearchCol is ColIterator+1,
%   ((nth0(RowIterator, Board, Line), nth0(ColIterator, Line, Piece1), nth0(SearchRow, Board, Line), nth0(SearchCol, Line, Piece2), Piece1 \= emptyCell, Piece1==Piece2) ->(
%     piece_value(Piece1, PieceValue), TempValue is TempValue + PieceValue * 5000
%     )
%   ),
%   SearchRow is RowIterator-1, SearchCol is ColIterator+1,
%   ((nth0(RowIterator, Board, Line), nth0(ColIterator, Line, Piece1), nth0(SearchRow, Board, Line), nth0(SearchCol, Line, Piece2), Piece1 \= emptyCell, Piece1==Piece2) ->(
%     piece_value(Piece1, PieceValue), TempValue is TempValue + PieceValue * 5000
%     )
%   ),
%   SearchRow is RowIterator-1, SearchCol is ColIterator,
%   ((nth0(RowIterator, Board, Line), nth0(ColIterator, Line, Piece1), nth0(SearchRow, Board, Line), nth0(SearchCol, Line, Piece2), Piece1 \= emptyCell, Piece1==Piece2) ->(
%     piece_value(Piece1, PieceValue), TempValue is TempValue + PieceValue * 5000
%     )
%   ),
%   SearchRow is RowIterator-1, SearchCol is ColIterator-1,
%   ((nth0(RowIterator, Board, Line), nth0(ColIterator, Line, Piece1), nth0(SearchRow, Board, Line), nth0(SearchCol, Line, Piece2), Piece1 \= emptyCell, Piece1==Piece2) ->(
%     piece_value(Piece1, PieceValue), TempValue is TempValue + PieceValue * 5000
%     )
%   ),
%   SearchRow is RowIterator, SearchCol is ColIterator-1,
%   ((nth0(RowIterator, Board, Line), nth0(ColIterator, Line, Piece1), nth0(SearchRow, Board, Line), nth0(SearchCol, Line, Piece2), Piece1 \= emptyCell, Piece1==Piece2) ->(
%     piece_value(Piece1, PieceValue), TempValue is TempValue + PieceValue * 5000
%     )
%   ),
%   SearchRow is RowIterator+1, SearchCol is ColIterator-1,
%   ((nth0(RowIterator, Board, Line), nth0(ColIterator, Line, Piece1), nth0(SearchRow, Board, Line), nth0(SearchCol, Line, Piece2), Piece1 \= emptyCell, Piece1==Piece2) ->(
%     piece_value(Piece1, PieceValue), TempValue is TempValue + PieceValue * 5000
%     )
%   ),
%   ColIteratorNext is ColIterator+1,
%   evaluate_line_state(Line, RemainingValue, RowIterator, ColIteratorNext),
%   LineValue is 1 + RemainingValue.


generate_random_component(RandomValue):-
  random(-10, 11, RandomValue).

evaluate_game_over(Board, GameOverValue):-
  (game_over(Board, Winner) ->(
    Winner == 'blackPlayer' -> piece_value(blackPiece, PieceValue), GameOverValue is PieceValue * 100000;
    Winner == 'whitePlayer' -> piece_value(whitePiece, PieceValue), GameOverValue is PieceValue * 100000
    );
    GameOverValue is 0
  ).
