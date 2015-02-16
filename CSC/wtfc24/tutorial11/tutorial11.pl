% -*- Mode: Prolog -*-


% Planning trips in Prolog.
% plane(A,B) means it is possible to travel from A to B on a plane.
% boat(A,B) means  it is possible to travel from A to B on a boat.
plane(to, ny).
plane(ny, london).
plane(london, bombay).
plane(london, oslo).
plane(bombay, katmandu).
boat(oslo, stockholm).
boat(stockholm, bombay).
boat(bombay, maldives).

% cruise(X,Y) -- there is a possible boat journey from X to Y.
cruise(X, Y) :- boat(X, Y);
	(boat(X, Z), cruise(Z, Y)).

% trip(X,Y) -- there is a possible journey (using plane or boat) from
% X to Y.
trip(X, Y) :- plane(X, Y);
	cruise(X, Y);
	((plane(X, Z); cruise(X, Z)), trip(Z, Y)).

% stopover(X,Y,S) -- there is a trip from X to Y with a stop in S.

% Let's make two attempts. Firstly, assume that neither X nor Y can
% equal S.
stopover(X, Y, S) :- trip(X, S), trip(S, Y).

% Now, assume S could be X or Y (or even both):
stopover(X, Y, S) :- trip(X, Y), (X==S; Y==S).

% plane_cruise(X,Y) -- there is a trip from X to Y that has at least
% one plane leg, and at least one boat leg.
plane_cruise(X, Y) :- trip(X, Y),
	plane(A, B), trip(X, A), trip(B, Y),
	boat(C, D), trip(X, C), trip(D, Y).

% Now, let's add costs to out trips.
plane(to, ny, 100).
plane(ny, london, 200).
plane(london, bombay, 500).
plane(london, oslo, 50).
plane(bombay, katmandu, 100).
boat(oslo, stockholm, 100).
boat(stockholm, bombay, 1000).
boat(bombay, maldives, 1000).

% cost(X,Y,C) -- there is a trip from X to Y that costs less than C.
cost(X, Y, C) :- ((plane(X, Y, D), D<C);
	(plane(X, A, D), D<C, cost(A, Y, C-D)));
	((boat(X, Y, D), D<C);
	(boat(X, A, D), D<C, cost(A, Y, C-D))).

% Practise working with lists in Prolog.

% reverse(?L, ?R) iff R is the reverse of list L.
% hint: use a built-in append/3.
% reverse([], []).
% reverse([H | T], R) :- reverse(T, P), append(P, [H], R).

% complexity of reverse? 
% n^2

% Now let's implement a linear-time reverse with an accumulator
reverse(L, R) :- reverse(L, [], R).

reverse([], Rev, Rev).
reverse([H | T], Prev, Rev) :- reverse(T, [H | Prev], Rev).

% a few simple set predicates
% intersect(?X,?Y,?Z) iff Z is the intersection of X and Y
% hint: there is a built-in member/2.
% hint: use not(blah(X,...)) which succeeds iff blah(X,...) fails.
intersect([], _, [])
intersect([H | T], L, [H | R]) :- member(H, L), intersect(T, L, R).
intersect([H | T], L, R) :- \+ member(H, L), intersect(T, L, R).

% union(?X,?Y,?Z) iff Z is the union of X and Y
union([], _, []).
union([H | T], L, [H, | R]) :- member(H, R), union(T, L, R).
union([H | T], L, R) :- \+ member(H, R), union(T, L, R).
% subset(?X,?Y) iff X is a subset of Y
subset([H | T], S) :- member(H, S), subset(T, S).
subset([], _).
