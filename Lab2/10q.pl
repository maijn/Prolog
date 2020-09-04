/*Dynamic procedures that updates during the game.*/
:-dynamic selected_sports/1. :- dynamic selected_sports/0.
:-dynamic has_played/1. :- dynamic has_played/0.
:-dynamic counter/1. :- dynamic counter/0.

selected_sports(empty).
has_played().
counter(0).

/* Static procedures that stays the same during execution.
List of all sports in this game and facts related to each sport. */
sports([tennis,football,basketball,swimming,running,boxing, volleyball, golf]).

tennis([court, racket, ball, timed, net, serve, numberOfTeamsPrGame=2, teamSize=2]).
football([field, ball, grass, timed, score, numberOfTeamsPrGame=2, teamSize=11]).
basketball([court, ball, timed, score, numberOfTeamsPrGame=2, teamSize=5]).
swimming([pool, water, lane, timed, numberOfTeamsPrGame=many, teamSize=1]).
running([track_and_field, bib, timed, numberOfTeamsPrGame=many, teamSize=1]).
boxing([boxing_ring, gloves, knock_out, score, numberOfTeamsPrGame=2, teamSize=1]).
volleyball([ball, teamSize=6, numberOfTeamsPrGame=2, net, timed, hall, court, beach, serve]).
golf([course, ball, grass, club, score, teamSize=1, numberOfTeamsPrGame=many, hole]).

/* Describes the game and prints when the game is started. */
description:-
  writeln('Theme is Sports!'),
  writeln('You have to guess which sport I think of.'),nl,
  writeln('Type "help" for instructions.'), nl,
  writeln('Let us start!').

/* Instructions of the game.*/
help:-
  writeln('has(X) - Form of query. Type has(<X>) to ask, e.g. has(ball).'),
  writeln('is(X) - Form of decision. Type is(<X>) when you know the answer, e.g. is(swimming).'),
  writeln('all_options - Get all available options.'),nl.

/** The game starts by calling start().
  
   How:
    Runs description() to get the game rules. Fills the list of all sports sports (line 6) and...
    The game starts by User guessing.
   */
            
start:-
  description,
  sports(L),
  remaining_sports(L),
  guessRule.

/* Handles the counter. If the counter exceeds maximum, the game ends.*/
checkCounter:-
  counter(X),
  (X<10);
  write('Out of questions to ask. End of Round. '),
  end.

/*THe main rule of the game - guessing.

  How:
    Firstly, checkCounter() checks number of queries.
    If counter < 10 -> ends the game.
    else -> reads User's input and run the entered command.
    */
guessRule:-
  checkCounter,
  read(I),
  I;
  end.
            
/* User gets all the available options they can play with.

  How:
    Concatenates all the lists and removes duplicates by using sort/2.
    Prints the options and User can guess.*/
all_options:-
  concat(L),
  sort(L,S),
  write('All options: '),
  writeln(S),nl,
  guessRule.

/* Loads the list of the seleceted sport.

  How:
    If input is X -> Loads the list related to the chosen sport.
    
  Args:
    X: Selected sport.
    L: List containing characteristicss related to X.
  */
getListOfSelected(X,L):-
  (X==tennis, tennis(L));
  (X==football, football(L));
  (X==basketball, basketball(L));
  (X==swimming, swimming(L));
  (X==running, running(L));
  (X==boxing, boxing(L));
  (X==volleyball, volleyball(L));
  (X==golf, golf(L)).

/* The form of query.

  How:
    Assigns the chosen sport S as a fact and gets the list L related to S.
    Checks if input X is a member in L.
    If yes ->
      prints Yes and increments counter by 1.
    If no but X is valid but not in L ->
      Get all the lists merged NewL and checks if X is in NewL. increments counter by 1.
    Else ->
      prints an error message to inform the User that the option is invalid.
    
    Args:
      X: Input by User.
    */
            
has(X):-
  /*Yes if X is in the list. increments counter by 1*/
  selected_sports(S),
  getListOfSelected(S,L),
  member(X,L),
  writeln('Yes!'),
  increment,
  guessRule;
  /*No if X is valid but not in the list. Increases counter by 1*/
  concat(NewL),
  member(X, NewL),
  writeln('No, try again.'),
  increment,
  guessRule;
  /*When the chosen option is not listed*/
  writeln('Invalid - Not in the list'),
  guessRule.
  
/* The form of decision where User guesses the current sport.
    
    How:
      Compares input X and current sport C.
      If X equals C -> end the game.
      Else -> increases counter by 1 and continues the game.
      
    Args:
      X: Input by User*/
      
is(X):-
  selected_sports(S),
  X==S,
  writeln('Successful guess! YOU GOT IT!'),
  end;
  write('Wrong guess. Keep up and try again!'),nl,
  increment,
  guessRule.


/* The end-predicate is called when the game is over.
  
  How:
    Asks if User wants to continue the game and reads input I.
    If I equals to y, then start the game again.
    If I equals to n, then abort.
    Else, call end again in order to get correct input which is either y or n.
    */
end:-
  writeln('Do you want to play again? (y/n)) '),
  read(I),
  (I=='y'->start()|I=='n'->abort);
  end.
      
/* The predicate/function handles which sports have not been guessed.
  
  How:
    It finds all X in has_played and inserts in list, P. It deletes all sports in P from L, resulting in a
    new list, V (V is a list for all sports that have not been guessed).
    If V is empty -> all sports have been guessed.
    If not, the program chooses a random available sport, S, from V and asserts into has_played
    so that S cannot be guessed. Furthermore, the previous sport is removed from selected_sports and insert
    the new sport, S. Lastly, the counter is reset.
    
    Args:
      L: List of all sports.
    */
remaining_sports(L):-
  findall(X, has_played(X), P),
  subtract(L, P, V),
  V\==[],
  random_member(S, V),
  assert(has_played(S)),
  retractall(selected_sports(_)),
  assertz(selected_sports(S)),
  retractall(counter(_)),
  assertz(counter(0));
                          
  writeln('All the sports are guessed!'),
  abort.
        
/* Merging all attributes into one big list, L.
  How:
    Stores all the facts related to the sport in A..H. Appending these lists
    into one big list. Finally, L contains all facts about each sport.
    
  Args:
    L: The big list which contains all the facts related to each sport.
    */
concat(L):-
  tennis(A),
  football(B),
  basketball(C),
  swimming(D),
  running(E),
  boxing(F),
  volleyball(G),
  golf(H),
  append(A,B, AB),
  append(C,D, CD),
  append(E,F, EF),
  append(G,H, GH),
  append(AB, CD, ABCD),
  append(EF, GH, EFGH),
  append(ABCD, EFGH, L).
        
/* Increasing the counter for each query.
    
  How:
    Gets counter(X) and increments X with 1, which is the new value,Y.
    Resets the current counter calling retractall/1 to the new incrementd value.*/
increment:-
  counter(X),
  Y is X+1,
  retractall(counter(X)),
  assertz(counter(Y)).
