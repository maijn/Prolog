/* Exercise 2:
The old Royal succession rule states that the throne is passed down along the
male line according to the order of birth before the consideration along the
female line – similarly according to the order of birth.
Queen Elizabeth, the monarch of United Kingdom, has four offsprings; namely:
-Prince Charles, Princess Ann, Prince Andrew and Prince Edward – listed in the
order of birth.*/

prince(charles).
prince(andrew).
prince(edward).
princess(ann).

older_than(charles,ann).
older_than(ann,andrew).
older_than(andrew,edward).

/* Declaring predicates to order of birth.*/
royal(X):- prince(X); princess(X).
is_older(X,Y):- older_than(X,Y).
is_older(X,Y):- older_than(X,Z), is_older(Z,Y).

/*Ordering the throne based on the old rule*/
is_higher(X,Y):- prince(X), prince(Y), is_older(X,Y).
is_higher(X,Y):- prince(X), princess(Y).

/* Algorithm for sorting*/
/*--OLD RULE--*/
add(A,[B|C],[B|D]):-
  not(is_higher(A,B)),
  add(A,C,D).
add(A,C,[A|C]).

/*--NEW RULE--*/
add(A,[B|C],[B|D]):-
  not(is_older(A,B)),
  add(A,C,D).
add(A,C,[A|C]).

sort_succession([A|B], Sorted):-
  sort_succession(B,Tail),
  add(A,Tail,Sorted).
sort_succession([],[]).

get_succession_list(ListSuccession):-
  findall(X, royal(X), List),
  sort_succession(List, ListSuccession).
