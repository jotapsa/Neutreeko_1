:- use_module(library(lists)).
%======================================%
%= @@ lists and matrices constructors =%
%======================================%

%======================================%
%= @@ lists and matrices manipulation =%
%======================================%

getMatrixElem(Row,Col, Matrix,Elem) :-
   nth0(Row,Matrix,RowList),
   nth0(Col,RowList,Elem).

% %%% 1. element row; 2. element column; 3. matrix; 4. query element.
% getMatrixElemAt(1, ElemCol, [ListAtTheHead|_], Elem):-
% 	getListElemAt(ElemCol, ListAtTheHead, Elem).
% getMatrixElemAt(ElemRow, ElemCol, [_|RemainingLists], Elem):-
% 	ElemRow > 1,
% 	ElemRow1 is ElemRow-1,
% 	getMatrixElemAt(ElemRow1, ElemCol, RemainingLists, Elem).
%
% %%% 1. element position; 2. list; 3. query element.
% getListElemAt(1, [ElemAtTheHead|_], ElemAtTheHead).
% getListElemAt(Pos, [_|RemainingElems], Elem):-
% 	Pos > 1,
% 	Pos1 is Pos-1,
% 	getListElemAt(Pos1, RemainingElems, Elem).

%%% 1. element row; 2. element column; 3. element to use on replacement; 3. current matrix; 4. resultant matrix.
setMatrixElemAtWith(0, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [NewRowAtTheHead|RemainingRows]):-
	setListElemAtWith(ElemCol, NewElem, RowAtTheHead, NewRowAtTheHead).
setMatrixElemAtWith(ElemRow, ElemCol, NewElem, [RowAtTheHead|RemainingRows], [RowAtTheHead|ResultRemainingRows]):-
	ElemRow > 0,
	ElemRow1 is ElemRow-1,
	setMatrixElemAtWith(ElemRow1, ElemCol, NewElem, RemainingRows, ResultRemainingRows).

%%% 1. position; 2. element to use on replacement; 3. current list; 4. resultant list.
setListElemAtWith(0, Elem, [_|L], [Elem|L]).
setListElemAtWith(I, Elem, [H|L], [H|ResL]):-
	I > 0,
	I1 is I-1,
	setListElemAtWith(I1, Elem, L, ResL).
