%======================================%
%= @@ lists and matrices manipulation =%
%======================================%

% Get a particular element of a matrix.
% getMatrixElemAt(+Row, +Col, +Matrix, -Elem)
getMatrixElemAt(Row, Col, Matrix,Elem) :-
   nth0(Row,Matrix,RowList),
   nth0(Col,RowList,Elem).

% Get a particular element from a list.
% getListElemAt(+N, +List, -Elem)
getListElemAt(N, List, Elem):-
  nth0(N, List, Elem).

% Set a particular element of a matrix.
%%% 1. element row; 2. element column; 3. element to use on replacement; 3. current matrix; 4. resultant matrix.
setMatrixElemAtWith(0, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [NewRowAtTheHead|RemainingRows]):-
	setListElemAtWith(ElemCol, NewElem, RowAtTheHead, NewRowAtTheHead).
setMatrixElemAtWith(ElemRow, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [RowAtTheHead|ResultRemainingRows]):-
	ElemRow > 0,
	ElemRow1 is ElemRow-1,
	setMatrixElemAtWith(ElemRow1, ElemCol, NewElem, RemainingRows, ResultRemainingRows).

% Set a particular element from a list.
%%% 1. position; 2. element to use on replacement; 3. current list; 4. resultant list.
setListElemAtWith(0, Elem, [_|L], [Elem|L]).
setListElemAtWith(I, Elem, [H|L], [H|ResL]):-
	I > 0,
	I1 is I-1,
	setListElemAtWith(I1, Elem, L, ResL).
