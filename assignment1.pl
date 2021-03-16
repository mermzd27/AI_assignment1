:- dynamic location/2.
:- dynamic notInfected.
:- dynamic Path.
begin :-
%    write('Write the number of rows you wish the map to have: '),
%    read(Size),
    neighbor([3,5],[2,5]).
generateMap(Size) :-
%    C is Size * Size,
%    write('Your map will have '),write(C),write('elements '),nl,
    assert(location(actor, [1,1])),
    assert(location(covid, [2,5])),
    assert(location(covid, [7,8])),   
    assert(location(mask, [8,2])),
    assert(location(home, [9,9])),
    assert(location(doctor, [5,5])),
    assert(notInfected([1, 1])).

% checks if 2 points on the map are adjustent is the top
neighbor([X,Y],Z) :- 
    Top is Y+1,
    Z=[X, Top].

% checks if 2 points on the map are adjustent is the bottom
neighbor([X,Y],Z) :- 
    Bottom is Y-1,
    Z=[X, Bottom].

% checks if 2 points on the map are adjustent is the left
neighbor([X,Y],Z) :- 
    L is X-1,
    Z=[L, Y].

% checks if 2 points on the map are adjustent is the right
neighbor([X,Y],Z) :- 
    R is X+1,
    Z=[R, Y].

% checks if the cell is infected by covid by checking if the position of covid is adjustent
covid_infected([X, Y]):-
  location(covid, Z), 
  neighbor([X, Y], Z).

% checks if the given position is the position of the mask
its_mask_position([X, Y]):-
    location(mask, Z),
	Z==[X,Y].

%checks if the given position is the position of the doctor
its_doctor_position([X, Y]):-
    location(doctor,Z),
	Z==[X,Y].

%to check if the given values are inside the borders of the map

inside_map([X,Y]):-
    X>0, X<10, Y>0, Y<10.

%to change the position when moving to the right

new(X,Y,X_1,Y,R):-
    X_1=X+1.

%to change the position when moving to the top

new(X,Y,X,Y_1,Top):-
    Y_1=Y+1.

%to change the position when moving to the bottom

new(X,Y,X,Y_1,Bottom):-
    Y_1=Y-1.

%to change the position when moving to the left

new(X,Y,X_1,Y,L):-
    X_1=X-1.

% initially empty path
findpath(Cell, Final)  :-
  backtrack([],Cell,Final).

backtrack(Path,Cell,[Cell|Path] )  :-
   home(Cell).

% keeps adding the path to the current cell 

backtrack(Path,Cell,Final)  :-
  edge(Cell,Cell1),
  depthfirst( [Cell|Path],Cell1,Final).

home([9,9]).

%see if the cell is covid infected
check(Point, _):-
    covid_infected(Point).

% when there is no covid infection, then it means that the neighbor cells are not covid cells
check(Point, _):-
  \+ covid_infected(Point),
  neighbor(Point, X),
  \+ notInfected(X), assert(notInfected(X)).

% if point is covid infected, then the adjustent might be covid
check(Point, _):-
  covid_infected(Point),
  adjacent(Point, X),
  \+ notInfected(X), assert(covid(X)).

