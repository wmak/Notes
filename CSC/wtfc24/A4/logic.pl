% -*- Mode : Prolog -*- 

% Any student walks, drives or takes public transit to school.
student(X) :- walks(X);
	drives(X);
	rides(X).

% All those who live where Andrew lives are students.
student(X) :- lives_at(X, Y),
	lives_at(andrew, Y).

% If the distance between the place where one lives and their school is greater
% that between High Park and St. George then they do not walk to school.
greater_than(X, Y) :- X > Y.
walks(X) :- lives_at(X, Y),
	studies_at(X, Z),
	distance(high_park, stgeorge, M),
	distance(Y, Z, N),
	greater_than(M,N).

% One can use some copyrighted data for commercial purposes only if the owner of
% the copyrighted data permits them to use it.
uses(X, Y) :- owns(Z, Y),
	permits(Z, X, Y).

% The copyright owner of the TTC maps permits exactly one user to use the maps
% define this one user as `user` and the owner as `ttcowner`, now only this one
% user is permitted to use ttcmaps
owns(ttcowner, ttcmaps).
permits(ttcowner, user, ttcmaps). % The one user allowed to use the maps
permits(X, Y, ttcmaps) :- X == ttcowner, 
	Y == user.
