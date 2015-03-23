
(define atom?
  (lambda (x)
    (and
     (not (pair? x)) (not (null? x)))))

(define lat?
  (lambda (l)
    (cond
     ((null? l) #t)
     ((atom? (car l)) (lat? (cdr l)))
     (else #f))))

(define member?
  (lambda (a lat)
    (cond
     ((null? lat) #f)
     (else (or (eq? (car lat) a)
	       (member? a (cdr lat)))))))

;; Rember: removes first occurrence of a member from a list
(define rember
  (lambda (a lat)
    (cond
     ((null? lat)          (quote ()))
     ((eq? (car lat) a)    (cdr lat))
     (else (cons (car lat)
		 (rember a (cdr lat)))))))

;; Firsts: constructs a list containing the first elements of each internal list
(define firsts
  (lambda (l)
    (cond
     ((null? l)           (quote ()))
     (else (cons (car (car l))
		 (firsts (cdr l)))))))

;; insertR: Inserts the element 'new' to the right of 'old' in list 'lat'
;; new: topping, old: fudge, lat: (ice cream with fudge for desert)
(define insertR
  (lambda (new old lat)
    (cond
     ((null? lat) (quote ()))
     (else
      (cond
       ((eq? (car lat) old)
	(cons old
	      (cons new (cdr lat))))
       (else (cons (car lat)
		   (insertR new old
			    (cdr lat)))))))))

;; insertL: Inserts the element 'new' to the left of 'old' in list 'lat'
;; Page 51
(define insertL
  (lambda (new old lat)
    (cond
     ((null? lat) (quote ()))
     (else
      (cond
       ((eq? (car lat) old) (cons new lat))
       (else (cons (car lat)
		   (insertR new old
			    (cdr lat)))))))))

;; multirember: Removes all occurrences of an element from list 'lat'
;; Page 53
(define multirember
  (lambda (a lat)
    (cond
     ((null? lat) (quote ()))
     (else
      (cond
       ((eq? (car lat) a) (multirember a (cdr lat)))
       (else (cons (car lat)
		 (multirember a (cdr lat)))))))))

;; multiinsertR: Inserts element 'new' to the right of every occurrence of 'old' in list 'lat'
;; Page 56
(define multiinsertR
  (lambda (new old lat)
    (cond
     ((null? lat) (quote ()))
     (else
      (cond
       ((eq? (car lat) old)
	(cons (car lat)
	      (cons new
		    (multiinsertR new old (cdr lat)))))
       (else (cons (car lat)
		   (multiinsertR new old (cdr lat)))))))))

;; multiinsertL: Inserts element 'new' to the left of every occurrence of 'old' in list 'lat'
;; Page 57
(define multiinsertL
  (lambda (new old lat)
    (cond
     ((null? lat) (quote ()))
     (else
      (cond
       ((eq? (car lat) old)
	(cons new
	     (cons old 
			(multiinsertL new old (cdr lat)))))
       (else (cons (car lat)
		   (multiinsertL new old (cdr lat)))))))))

;; multisubst: Replaces all occurrences of element 'old' in list 'lat' with 'new'
;; Page 57
(define multisubst
  (lambda (new old lat)
    (cond
     ((null? lat) (quote ()))
     (else (cond
	    ((eq? (car lat) old)
	     (cons new
		   (multisubst new old (cdr lat))))
	    (else (cons (car lat)
			(multisubst new old (cdr lat)))))))))

;; add1: Returns the value n+1 for some n
;; Page 59
(define add1
  (lambda (n)
    (+ n 1)))

;; sub1: Returns the value n-1 for some n
;; Page 59
(define sub1
  (lambda (n)
    (- n 1)))

;; ++: Rewrites addition for non-negative integers
;; Page 60
(define ++
  (lambda (n m)
    (cond
     ((zero? m) n)
     (else (add1 (++ n (sub1 m)))))))

;; --: Rewrites substraction for non-negative integers
;; Page 61
(define --
  (lambda (n m)
    (cond
     ((zero? m) n)
     (else (sub1 (-- n (sub1 m)))))))

;; addtup: Totals the numbers in tuple 'tup'
;; Introduced on page 62; formalised on page 64
(define addtup
  (lambda (tup)
    (cond
     ((null? tup) 0)
     ;; Let's use ++ for fun
     (else (++ (car tup) (addtup (cdr tup)))))))

;; **: Rewrites multiplication for non-negative integers
;; Page 65
(define **
  (lambda (n m)
    (cond
     ((zero? m) 0)
     (else (++ n (** n (sub1 m)))))))

;; tup+: Adds the elements of tup1 to tup2 at each position
;; Page 69
(define tup+
  (lambda (tup1 tup2)
    (cond
     ((null? tup1) tup2)
     ((null? tup2) tup1)
     (else
      (cons (+ (car tup1) (car tup2))
	    (tup+ (cdr tup1) (cdr tup2)))))))

;; >>: Rewrites the greater-than function for non-negative integers
;; Page 72
(define >>
  (lambda (n m)
    (cond
     ((zero? n) #f)
     ((zero? m) #t)
     (else (>> (sub1 n) (sub1 m))))))
  
;; <<: Rewrites the less-than function for non-negatie integers
;; Page 73
(define <<
  (lambda (n m)
    (cond
     ((zero? m) #f)
     ((zero? n) #t)
     (else (<< (sub1 n) (sub1 m))))))

;; ==: Rewrites equality using << and >>
;; Page 74
(define ==
  (lambda (n m)
    (cond
     ((>> n m) #f)
     ((<< n m) #f)
     (else #t))))

;; ^: Rewrites exponentiation for non-negative integers
;; Page 74
(define ^
  (lambda (n m)
    (cond
     ((zero? m) 1)
     (else (** n (^ n (sub1 m)))))))

;; //: Rewrites division for non-negative integers
;; Page 75
(define //
  (lambda (n m)
    (cond
     ((<< n m) 0)
     ;; Count the number of subtractions until (<< n m)
     (else (add1 (// (-- n m) m))))))

;; length1: Rewrites the length function, which counts the elements in list 'lat'
;; Page 76
(define length1
  (lambda (lat)
    (cond
     ((null? lat) 0)
     (else (add1 (length1 (cdr lat)))))))

;; pick: Returns the value in list 'lat' at position 'n'
;; Page 76
(define pick
  (lambda (n lat)
    (cond
     ((zero? (sub1 n)) (car lat))
     (else (pick (sub1 n) (cdr lat))))))

;; rempick: Removes the value in list 'lat' at position 'n'
;; Page 76
(define rempick
  (lambda (n lat)
    (cond
     ((zero? (sub1 n)) (cdr lat))
     (else (cons (car lat)
		 (rempick (sub1 n) (cdr lat)))))))

;; no-nums: Removes all numbers from list 'lat'
;; Page 77
(define no-nums
  (lambda (lat)
    (cond
     ((null? lat) (quote ()))
     (else (cond
	    ((number? (car lat)) (no-nums (cdr lat)))
	    (else (cons (car lat)
			(no-nums (cdr lat)))))))))

;; all-nums: Returns the list of all numbers in list 'lat'
;; Page 78
(define all-nums
  (lambda (lat)
    (cond
     ((null? lat) (quote ()))
     (else (cond
	    ((number? (car lat))
	     (cons (car lat)
		   (all-nums (cdr lat))))
	    (else (all-nums (cdr lat))))))))

;; eqan?: Tests whether a1 and a2 are the same atom
;; Page 78
(define eqan?
  (lambda (a1 a2)
    (cond
     ((and (number? a1) (number? a2))
      (== a1 a2))
     ((or (number? a1) (number? a2))
      #f)
     (else (eq? a1 a2)))))

;; occur: Counts the number of times an atom appears in list 'lat'
;; Page 78
(define occur
  (lambda (a lat)
    (cond
     ((null? lat) 0)
     (else (cond
	    ((eq? a (car lat))
	     (add1 (occur a (cdr lat))))
	    (else (occur a (cdr lat))))))))

;; one?: Tests whether a value equals 1
;; Page 79
;; First definition
(define one?
  (lambda (n)
    (cond
     ((zero? n) #f)
     (else (zero? (sub1 n))))))

;; Second definition
(define _one?
  (lambda (n)
    (cond
     (else (= n 1)))))

;; Third definition
(define __one?
  (lambda (n)
    (= n 1)))

;; rempick1: Rewrites rempick, which removes the nth atom from list 'lat'
;; Page 79
(define rempick1
  (lambda (n lat)
    (cond
     ((one? n) (cdr lat))
     (else (cons (car lat)
		 (rempick1 (sub1 n)
			   (cdr lat)))))))

;; rember*: Removes all occurrences of 'a' in list 'l'
;; Page 81
(define rember*
  (lambda (a l)
    (cond
     ((null? l) (quote ()))
     ((atom? (car l))
      (cond
       ((eq? (car l) a)
	(rember* a (cdr l)))
       (else (cons (car l)
		   (rember* a (cdr l))))))
     (else (cons (rember* a (car l))
		 (rember* a (cdr l)))))))

;; insertR: Inserts the atom 'new' at the right of every 'old'
;; Page 82
(define insertR*
  (lambda (new old l)
    (cond
     ((null? l) (quote ()))
     ((atom? (car l))
      (cond
       ((eq? (car l) old)
	(cons old
	      (cons new
		    (insertR* new old (cdr l)))))
       (else (cons (car l)
		   (insertR* new old (cdr l))))))
     (else (cons (insertR* new old (car l))
		 (insertR* new old (cdr l)))))))

;; occur*: Totals the number of occurrences of atom 'a' in list 'l'
;; Page 85
(define occur*
  (lambda (a l)
    (cond
     ((null? l) 0)
     ((atom? (car l))
      (cond
       ((eq? (car l) a)
	(add1 (occur* a (cdr l))))
       (else (occur* a (cdr l)))))
     (else (++ (occur* a (car l))
	       (occur* a (cdr l)))))))

;; subst*: Replaces all occurrences of 'old' with 'new' in list 'l'
;; Page 85
(define subst*
  (lambda (new old l)
    (cond
     ((null? l) (quote ()))
     ((atom? (car l))
      (cond
       ((eq? old (car l))
	(cons new
	      (subst* new old (cdr l))))
       (else
	(cons (car l)
	      (subst* new old (cdr l))))))
      (else
       (cons (subst* new old (car l))
	     (subst* new old (cdr l)))))))

;; insertL*: Add 'new' to the left of every occurrence of 'old' in list 'l'
;; Page 86
(define insertL*
  (lambda (new old l)
    (cond
     ((null? l) (quote ()))
     ((atom? (car l))
      (cond
       ((eq? (car l) old)
	(cons new
	      (cons old
		    (insertL* new old (cdr l)))))
       (else (cons (car l)
		   (insertL* new old (cdr l))))))
     (else (cons (insertL* new old (car l))
		 (insertL* new old (cdr l)))))))

;; member*: Tests whether atom 'a' exists in list 'l'
;; Page 87
(define member*
  (lambda (a l)
    (cond
     ((null? l) #f)
     ((atom? (car l))
      (or (eq? (car l) a)
	  (member* a (cdr l))))
     (else
      (or (member* a (car l))
	  (member* a (cdr l)))))))

;; leftmost: Returns the leftmost atom in a list
;; Page 87
(define leftmost
  (lambda (l)
    (cond
     ((atom? (car l)) (car l))
     (else (leftmost (car l))))))

;; eqlist?: Determines whether two lists are identical
;; Page 91
(define eqlist?
  (lambda (l1 l2)
    (cond
     ((and (null? l1) (null? l2)) #t)
     ((or (null? l1) (null? l2)) #f)
     ((and (atom? (car l1)) (atom? (car l2)))
      (and (eqan? (car l1) (car l2))
	   (eqlist? (cdr l1) (cdr l2))))
     ;; Below line is an optimisation to prevent needless recursion
     ((or (atom? (car l1)) (atom? (car l2))) #f)
     (else
      (and (eqlist? (car l1) (car l2))
	   (eqlist? (cdr l1) (cdr l2)))))))

;; equal1?: Rewrites equal?, which tests whether two S-expressions are equal
;; Page 93
(define equal1?
  (lambda (s1 s2)
    (cond
     ((and (atom? s1) (atom? s2))
      (eqan? s1 s2))
     ((or (atom? s1) (atom? s2)) #f)
     (else (eqlist? s1 s2)))))

;; eqlist1?: Rewrites eqlist? using equal?
;; Page 93
(define eqlist1?
  (lambda (l1 l2)
    (cond
     ((and (null? l1) (null? l2)) #t)
     ((or (null? l1) (null? l1)) #f)
     (else (and (equal? (car l1) (car l2))
		(eqlist1? (cdr l1) (cdr l2)))))))

;; rember1: Simplified definition of rember, removes the first
;; S-expression as opposed to the first matching atom in list 'l'
;; Page 64
(define rember1
  (lambda (s l)
    (cond
     ((null? l) (quote ()))
     (else (cond
	    ((equal? (car l) s) (cdr l))
	    (else (cons (car l)
			(rember1 s (cdr l)))))))))


;; rember2: Simplified definition of rember1
;; Page 95
(define rember2
  (lambda (s l)
    (cond
     ((null? l) (quote ()))
     ((equal? (car l) s) (cdr l))
     (else (cons (car l)
		 (rember2 s (cdr l)))))))

;; numbered?: Determines whether a representation of an
;; arithmetic expressions constains only numbers besides
;; the ++, ** and ^
;; Pages 98-101
(define numbered?
  (lambda (aexp)
    (cond
     ((atom? aexp) (number? aexp))
     (else
      (and (numbered? (car aexp))
	   (numbered? (car (cdr (cdr aexp)))))))))

;; first-sub-exp: Retrieves the first sub-expression
;; of an arithmetic expression
;; Page 105
(define first-sub-exp
  (lambda (aexp)
    (car aexp)))

;; second-sub-exp: Retrieves the second sub-expression
;; of an arithmetic expression
;; Page 106
(define second-sub-exp
  (lambda (aexp)
    (car (cdr (cdr aexp)))))

;; operator: Retrieves the operator of an arithmetic expression
;; Page 106
(define operator
  (lambda (aexp)
    (car (cdr aexp))))

;; value: Returns the value of a numbered arithmetic expression
;; Pages 102-106
(define value
  (lambda (nexp)
    (cond
     ((atom? nexp) nexp)
     ((eq? (operator nexp) (quote +))
      (++ (value (first-sub-exp nexp))
	  (value (second-sub-exp nexp))))
     ((eq? (operator nexp) (quote *))
      (** (value (first-sub-exp nexp))
	  (value (second-sub-exp nexp))))
     (else
      (^ (value (first-sub-exp nexp))
	 (value (second-sub-exp nexp)))))))

;; Definitions for representing numbers using a list of empty lists
;; sero?: Tests for zero with this new representation
;; Page 108
(define sero?
  (lambda (n)
    (null? n)))

;; edd1: Analogous to add1
;; Page 108
(define edd1
  (lambda (n)
    (cons (quote ()) n)))

;; zub1: Analogous to sub1
;; Page 108
(define zub1
  (lambda (n)
    (cdr n)))

;; +!: Analogous to +
;; Page 108
(define +!
  (lambda (n m)
    (cond
     ((sero? m) n)
     (else (edd1 (+! n (zub1 m)))))))

;; llat?: Analogous to 'lat?'
;; Page 109
(define llat?
  (lambda (l)
    (cond
     ((null? l) #t)
     ((atom? (car l))
      (llat? (cdr l)))
     (else #f))))
