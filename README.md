# The Little and Seasoned Schemer

Study resources for [The Little Schemer](http://mitpress.mit.edu/books/little-schemer) and [The Seasoned Schemer](https://mitpress.mit.edu/books/seasoned-schemer).

Contains:
* Scheme files with function definitions developed during each book (tested under [Chicken](http://www.call-cc.org/))
* The Little and Seasoned Schemer Commandments (below)
* [Supporting literature](/literature/)
  * "Applications of Continuations" – Daniel P. Friedman
  * "A Tutorial Introduction to the Lambda Calculus" – Raul Rojas

## The Little and Seasoned Schemer Commandments

1. The first condition when recursing through a list should be `(null? lat)`
   When recursing with numbers, ask `(zero? n)` and 'else'

2. Use `cons` to build lists

3. When building a list, describe the first typical element and `cons` it onto the recursion

4. Always change at least one argument when recurring.
   When recurring with atoms, `lat`, use `(car lat)`.  When recurring on a
number, `n`, use `(sub1 n)`.  When recurring on a list of S-expressions, `l`,
use `(car l)` and `(cdr l)` if neither `(null? l)` nor `(atom? (car l))`
are true.  When using `cdr`, test termination with `null?`; when using `sub1`, test
termination with `zero?`.
	
5. When building a value with `+`, always use `0` for the value of the terminating
   line, for adding `0` does not change the value of an addition.
   When building a value with `*`, always use `1` for the value of the terminating
   line, for multiplying by 1 does not change the value of a multiplicaiton.
   When building a value with `cons`, always consider `()` for the value of the
   terminating line

6. Simplify only after the function is correct

7. Recur on the subparts that are of the same nature:
* On the sublists of a list
* On the subexpressions of an arithmetic expression

8. Use help functions to abstract from representations

9. Abstract common patterns with a new function

10. Build functions to collect more than one value at a time

11. Use additional arguments when a function needs to know what other
arguments to the function have been like so far

12. Use `(letrec ...)` to remove arguments that do not change for recursive
applications

