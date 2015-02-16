% -*- Mode : Prolog -*- 

:- use_module(prop, [formula/1, eval/3]).

same_set(Xs, Ys) :- subset(Xs, Ys), subset(Ys, Xs).

:- begin_tests(lists).
:- use_module(library(lists)).

test(formula, fail) :-
        formula(x).

test(formula) :- 
	formula(variable(x)).

test(formula) :-
	formula(or([variable(a), tru, variable(c)])).

test(formula) :-
	formula(implies(variable(a), and([variable(b), neg(fls)]))).

test(sub) :-
	findall(G, sub(variable(a), [a/tru, b/fls], G), Gs),
	Gs == [tru].

test(sub) :-
	findall(G, sub(or([variable(a)]), [a/tru, b/fls], G), Gs),
	Gs == [or([tru])].

test(sub) :-
	findall(A, sub(neg(variable(x)), A, neg(tru)), As), 
	As == [[x/tru]].

test(sub) :-
	findall(A, sub(implies(variable(x), variable(y)), A, implies(tru, tru)), As)
	, As == [[x/tru, y/tru]].

test(eval) :-
	findall(V, eval(variable(a), [a/tru, b/fls], V), Vs),
	Vs == [tru].

test(eval) :-
	findall(V, eval(or([variable(a)]), [a/tru, b/fls], V), Vs),
	Vs == [tru].

test(eval) :-
	findall(V, eval(or([variable(a), variable(b)]), [a/tru, b/tru], V), Vs),
	Vs == [tru].

test(eval) :-
	findall(V, eval(and([variable(a)]), [a/tru, b/fls], V), Vs),
	Vs == [tru].

test(eval) :-
	findall(V, eval(and([variable(a), variable(b)]), [a/tru, b/tru], V), Vs),
	Vs == [tru].

test(eval) :-
	findall(Asst, eval(implies(variable(a), and([variable(b), neg(fls)])),
	                Asst,
			tru),
		Assts),
	member(A1, Assts), member(a/tru, A1), member(b/tru, A1),
	member(A2, Assts), member(a/fls, A2), member(b/tru, A2),
	member(A3, Assts), member(a/fls, A3), member(b/fls, A1).

:- end_tests(lists).
