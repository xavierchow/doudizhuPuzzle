# doudizhuPuzzle
This tries to find the solution of doudizhu puzzle.

![Image](../master/puzzle.png?raw=true)

#Rules
The tenant(nongmin?) and landlord(dizhu?) know the hands each other.

* Single card '2' is the smallest, '2'<'3'<...<'J'<'Q'<'K'<'A'<'BlackJocker'<'RedJocker'
* Pair (2) is OK.
* Trip with kicker (3+1) is OK.
* Trip (3) is OK.
* BUT Trip with two kickers (3+2) (fullhouse) is NOT allowed.
* Quads (4) is OK and it's a bomb which can win anything else except Jocker Pair.
* Quads with kicker (4+2) is OK, but it's not a bomb.
* Straight (3,4,5,6,7) is OK, BUT flush ( 5 cards in same type) is not allowed.
* RedJocker and BlackJocker together is the biggest bomb which can beat anything.

the tenant plays first.


#Notes
I found an algorithm for exploring the solution, but the performance is a big problem, the program runs out of memory with the cards above. So I do some [analysis](https://github.com/xavierchow/doudizhuPuzzle/wiki/Some-Analysis) to narrow the scale.
The answer I found is that the tenant will never win, please let me know if I'm wrong.
