
;; atom?: Determines whether the argument is an atom
;; Preliminary
(define atom?
  (lambda (x)
    (and (not (pair? x))
	 (not (null? x)))))

;; two-in-a-row?: Determines whether two atoms appear sequentially in a list
;; Page 6
(define two-in-a-row?
  (lambda (lat)
    (cond
     ((null? lat) #f)
     (else (or (is-first-b? (car lat) (cdr lat)))))))

;; is-first-b?: Helper function to two-in-a-row?
;; Page 6
(define is-first-b?
  (lambda (a lat)
    (cond
     ((null? lat) #f)
     (else (or (eq? (car lat) a)
	       (two-in-a-row? lat))))))

;; two-in-a-row-b?: Alternate version of two-in-a-row?
;; Page 7
(define two-in-a-row-b?
  (lambda (preceding lat)
    (cond
     ((null? lat) #f)
     (else (or (eq? (car lat) preceding)
	       (two-in-a-row-b? (car lat) (cdr lat)))))))

;; two-in-a-row-c: Final version of two-in-a-row?
;; Page 7
(define two-in-a-row-c
  (lambda (lat)
    (cond
     ((null? lat) #f)
     (else two-in-a-row-b? (car lat) (cdr lat)))))

;; sum-of-prefixes: For a given list, returns a new list such that each
;; element is the sum of that element and all of its preceding elements
;; Page 9-11
(define sum-of-prefixes
  (lambda (tup)
    (sum-of-prefixes-b 0 tup)))

;; sum-of-prefixes-b: Helper function to sum-of-prefixes: returns a list
;; where each element is the cumulative sum of each element of the
;; argument list
;; Page 10
(define sum-of-prefixes-b
  (lambda (sonssf tup)
    (cond
     ((null? tup) (quote ()))
     (else (cons (+ sonssf (car tup))
		 (sum-of-prefixes-b (+ sonssf (car tup))
				    (cdr tup)))))))

;; scramble: Takes a tup in which no number is greater than its index.  Each
;; number is treated as a reference to a previous index; the result at each
;; position is found by counting backward from the current position according
;; to this index (i.e. position minus index)
;; Page 15
(define scramble
  (lambda (tup)
    (scramble-b tup (quote ()))))

;; pick: Retrieves the nth element from a given list
;; Page 13
(define pick
  (lambda (n lat)
    (cond
     ((eq? n 1) (car lat))
     (else (pick (- n 1)
		 (cdr lat))))))

;; scramble-b: Helper function to scramble
;; Page 14
(define scramble-b
  (lambda (tup rev-pre)
    (cond
     ((null? tup) (quote ()))
     (else
      (cons (pick (car tup)
		  (cons (car tup) rev-pre))
	    (scramble-b (cdr tup)
			(cons (car tup) rev-pre)))))))

;; multirember: multirember from The Little Schemer using the Y combinator
;; so we don't have to pass the removal element through every recursive call
;; Page 17
(define multirember
  (lambda (a lat)
    ((Y (lambda (mr)
	  (lambda (lat)
	    (cond
	     ((null? lat) (quote ()))
	     ((eq? a (car lat))
	      (mr (cdr lat)))
	     (else (cons (car lat)
			 (mr (cdr lat))))))))
     lat)))

;; Y: Y combinator
;; From The Little Schemer
(define Y
  (lambda (le)
    ((lambda (f) (f f))
     (lambda (f)
       (le (lambda (x) ((f f) x)))))))

;; length: Length of a list using the Y combinator
;; Page 17
(define length
  (Y (lambda (length)
       (lambda (l)
	 (cond
	  ((null? l) 0)
	  (else
	   (+ 1 (length (cdr l)))))))))

;; mrletrec: multirember in the letrec style
;; Page 22
(define mrletrec
  (lambda (a lat)
    (letrec
	((mr (lambda (lat)
	       (cond
		((null? lat) (quote ()))
		((eq? a (car lat))
		 (mr (cdr lat)))
		(else
		 (cons (car lat)
		       (mr (cdr lat))))))))
      (mr lat))))

;; multirember-f: Removes an atom from a list of atoms according to some
;; test function
;; Page 23
(define multirember-f
  (lambda (test?)
    (lambda (a lat)
      (cond
       ((null? lat) (quote ()))
       ((test? (car lat) a)
	((multirember-f test?) a (cdr lat)))
       (else (cons (car lat)
		   ((multirember-f test?) a (cdr lat))))))))

;; multirember-f-2: multirember-f using letrec
;; Page 24
(define multirember-f-2
  (lambda (test?)
    (letrec
	((m-f
	  (lambda (a lat)
	    (cond
	     ((null? lat) (quote ()))
	     ((test? (car lat) a)
	      (m-f a (cdr lat)))
	     (else
	      (cons (car lat)
		    (m-f a (cdr lat))))))))
      m-f)))

;; multirember-eq: multirember-f-2 where test? is eq?
;; Page 25
(define multirember-eq
  (letrec
      ((mr (lambda (a lat)
	     (cond
	      ((null? lat) (quote ()))
	      ((eq? (car lat) a)
	       (mr a (cdr lat)))
	      (else
	       (cond (car lat)
		     (mr a (cdr lat))))))))
    mr))

;; member?: Determines whether an atom is a member of a list
;; page 26
(define member?
  (lambda (a lat)
    (cond
     ((null? lat) #f)
     ((eq? a (car lat)) #t)
     (else (member? a (cdr lat))))))

;; member?-2: member? in letrec style
;; Page 27
(define member?-2
  (lambda (a lat)
    (letrec
	((yes? (lambda (l)
		 (cond
		  ((null? l) #f)
		  ((eq? (car l) a) #t)
		  (else (yes? (cdr l)))))))
      (yes? lat))))
