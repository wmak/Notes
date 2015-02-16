% -*- Mode : Prolog -*- 

:- module(prop, [formula/1, sub/3, eval/3]).

% A predicate formula(?F), that succeeds iff F is a valid formula.
% tru and fls are formulas
formula(tru).
formula(fls).

% variable(V) is a formula iff V is an atom
formula(variable(V)) :- atom(V).

% neg(F) is a formula iff F is a formula
formula(neg(F)) :- formula(F).

% and(FList) is a formula iff every element in the list FList is a formula
formula(and([H | T])) :- formula(H), formula(and(T)).
formula(and([])).

% or(FList) is a formula iff every element in the list FList is a formula
formula(or([H | T])) :- formula(H), formula(or(T)).
formula(or([])).

% implies(F0, F1) is a formula iff both F0 and F1 are formulae.
formula(implies(F0, F1)) :- formula(F0), formula(F1).

% sub(?F, ?Asst, ?G) succeeds iff G is a formula which is a result of 
% substituting the variables of F with corresponding values from the assigntment
% Asst.
sub(variable(Ha), [Ha/Hb], Hb) :- !.
sub(variable(Ha), [Ha/Hb| _], Hb) :- !.
sub(variable(X), [Ha/_ | T], G) :- sub(variable(X), T, G), X\==Ha, !. 
sub(variable(X), [], variable(X)). 

sub(neg(X), Asst, neg(Ga)) :- sub(X, Asst, Ga).

sub(and([H | T]), A3, and([Ga | Gb])) :- sub(H, A1, Ga), 
	sub(and(T), A2, and(Gb)), union(A1, A2, A3).
sub(and([]), _, and([])).

sub(or([H | T]), A3, or([Ga | Gb])) :- sub(H, A1, Ga), 
	sub(or(T), A2, or(Gb)), union(A1, A2, A3).
sub(or([]), _, or([])).

sub(implies(F0, F1), Asst, implies(Ga, Gb)) :- sub(F0, A1, Ga), 
	sub(F1, A2, Gb), union(A1, A2, Asst).

% eval(?F, ?A, ?V) succeeds iff the formula F has value V (either tru or fls)
% under the assignment of values to variables A.
eval(tru, _, tru).
eval(fls, _, fls).

eval(variable(Ha), [Ha/V], V) :- (V==tru; V==fls), !.
eval(variable(Ha), [Ha/V| _], V) :- (V==tru; V==fls), !.
eval(variable(X), [Ha/_ | T], V) :- eval(variable(X), T, V), X\==Ha, !. 
eval(variable(X), [], variable(X)). 

eval(neg(X), Asst, tru) :- eval(X, Asst, fls).
eval(neg(X), Asst, fls) :- eval(X, Asst, tru).

eval(and([H | T]), A3, tru) :- eval(H, A1, tru), 
	eval(and(T), A2, tru), union(A1, A2, A3).
eval(and([H | T]), A3, fls) :- (eval(H, A1, fls);
	eval(and(T), A2, fls)), union(A1, A2, A3).
eval(and([]), _, tru).

eval(or([H | T]), A3, tru) :- (eval(H, A1, tru);
	eval(or(T), A2, tru)), union(A1, A2, A3).
eval(or([H | T]), A3, fls) :- eval(H, A1, fls),
	eval(and(T), A2, fls), union(A1, A2, A3).
eval(or([]), _, tru).

eval(implies(F0, F1), Asst, tru) :- eval(F0, A1, V), eval(F1, A2, V), 
	union(A1, A2, Asst).
eval(implies(F0, F1), Asst, tru) :- eval(F0, A1, _), eval(F1, A2, fls),
	union(A1, A2, Asst).
eval(implies(F0, F1), Asst, fls) :- eval(F0, A1, fls), eval(F1, A2, tru),
	union(A1, A2, Asst).
