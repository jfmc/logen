

/* Unification of ground terms with occurs check */
/* program taken from a Lopstr'92 article by */
/*	J. Gallagher & D.A. de Waal: 30/6/91 */

/* test: ?-unify(struct(f,[var(1),var(2)]),struct(f,[var(3),var(3)]),S). */
/* test: ?-unify(struct(f,[var(1),var(1)]),struct(f,[var(2),var(3)]),S). */

/* pe: unify(struct(p,[X]),struct(p,[struct(a,[])]),Sub). */
/* pe: unify(X,struct(f,[Y]),Sub). */

unify(X,Y,S) :-
	unify(X,Y,[],S).




unify(var(N),T,S,S1) :-
	bound(var(N),S,B,V),
	unify(var(N),T,S,S1,B,V).
unify(struct(F,Args),var(N),S,S1) :-
	unify(var(N),struct(F,Args),S,S1).
unify(struct(F,Args1),struct(F,Args2),S,S2) :-
	unifyargs(Args1,Args2,S,S2).


unify(var(_),T,S,S1,B,true) :-
	unify(B,T,S,S1).
unify(var(N),T,S,S1,_,false) :-
	unify1(T,var(N),S,S1).


unifyargs([],[],S,S).
unifyargs([T|Ts],[R|Rs],S,S2) :-
	unify(T,R,S,S1),
	unifyargs(Ts,Rs,S1,S2).


unify1(struct(F,Args),var(N),S,[var(N)/struct(F,Args)|S]).
% removed for bta checking: unification wo occurs check
%unify1(struct(F,Args),var(N),S,[var(N)/struct(F,Args)|S]) :-
%	\+(occur_args(var(N),Args,S)).
unify1(var(N),var(N),S,S).
unify1(var(M),var(N),S,S1) :-
	M \== N,
	bound(var(M),S,B,V),
	unify1(var(M),var(N),S,S1,B,V).
unify1(var(_),var(N),S,S1,B,true) :-
	unify1(B,var(N),S,S1).
unify1(var(M),var(N),S,[var(N)/var(M)|S],_,false).



bound(var(N),[var(N)/T|_],T,true) :-
	T \== var(N).
bound(var(N),[B/_|S],T,F) :-
	B \== var(N),
	bound(var(N),S,T,F).
bound(var(_),[],_,false).



dereference(var(N),[var(N)/T|_],T) :-
	T \== var(N).
dereference(var(N),[B/_|S],T) :-
	B \== var(N),
	dereference(var(N),S,T).



occur(var(N),var(M),S) :-
	dereference(var(M),S,T),
	occur(var(N),T,S).
occur(var(N),var(N),_).
occur(var(N),struct(_,Args),S) :-
	occur_args(var(N),Args,S).

occur_args(var(N),[A|_],S) :-
	occur(var(N),A,S).
occur_args(var(N),[_|As],S) :-
	occur_args(var(N),As,S).



