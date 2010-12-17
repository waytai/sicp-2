(cons 1 2)
(cons (cons 1 2) (cons 3 4))
(cons (cons 1 (cons 2 3)) 4)

(cons 1 (cons 2 (cons 3 (cons 4 nil))))

(define one-through-four (list 1 2 3 4))

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))

(define squares (list 1 4 9 16 25))

(list-ref squares 3)

(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items))))
  
(define odds (list 1 3 5 7))

(length odds)

(define (length items)
  (define (length-iter a count)
    (if (null? a)
        count
        (length-iter (cdr a) (+ 1 count))))
  (length-iter items 0))

(append squares odds)

(append odds squares)

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))

;> (append '(1) 2)
;(1 . 2)
;> (append '(1) '(2))
;(1 2)
;> 

; ex 2.17
(list-pair (list 23 72 149 34))

(define (list-pair list)
  (if (null? (cdr (cdr list)))
      (cdr list)
      (list-pair (cdr list))))
      
      
; ex 2.18

(reverse (list 1 4 9 16 25))

(define (reverse list)
  (if (null? (cdr list))
      list
      (cons (reverse (cdr list)) (car list))))

(define (reverse list)
  (define (reverse-iter list result)
    (if (null? list)
        result
        (reverse-iter (cdr list) (cons (car list) result))))
  (reverse-iter list '()))

; ex 2.19
(define us-coins (list 50 25 10 5 1))

(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(cc 100 us-coins)

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
        ((or (< amount 0) (no-more? coin-values)) 0)
        (else
         (+ (cc amount
                (except-first-denomination coin-values))
            (cc (- amount
                   (first-denomination coin-values))
                coin-values)))))

(define (except-first-denomination list)
  (cdr list))

(define (first-denomination list)
  (car list))

(define (no-more? list)
  (null? list))        

(define us-coins2 (list 1 5 10 25 50))

(cc 100 us-coins2)

(cc 100 us-coins)
(cc 100 (reverse us-coins))

(cc 100 uk-coins)

;; no effect

; ex 2.20  
(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)
(same-parity ) ;; TODO

(define (same-parity . n)
  (define (same-parity-inter l parity result)
    (if (null? l)
        result
        (if (boolean=? parity (even? (car l)))
            (same-parity-inter (cdr l) parity (append result (list (car l))))
            (same-parity-inter (cdr l) parity result))))
  (same-parity-inter n (even? (car n)) '()))

; list mapping

(define (scale-list items factor)
  (if (null? items)
      '()
      (cons (* (car items) factor)
            (scale-list (cdr items) factor))))

(scale-list (list 1 2 3 4 5) 10)

(map + (list 1 2 3) (list 40 50 60) (list 700 800 900))

(map (lambda (x y) (+ x (* 2 y)))
     (list 1 2 3)
     (list 4 5 6))

(define (map proc items)
  (if (null? items)
      nil
      (cons (proc (car items))
            (map proc (cdr items)))))

(map abs (list -10 2.5 -11.6 17))

(define (scale-list items factor)
  (map (lambda (x) (* x factor))
       items))

; ex 2.21
(square-list (list 1 2 3 4))

(define (square-list items)
  (if (null? items)
      '()
      (cons (* (car items) (car items))
            (square-list (cdr items)))))

(define (square-list items)
  (map (lambda (x) (* x x))
       items))

; ex 2.22
(define (square x)
  (* x x))

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons (square (car things))
                    answer))))
  (let ((result (iter items '())))
    (reverse result)))
               
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
        answer
        (iter (cdr things)
              (cons answer
                    (square (car things))))))
  (iter items '()))

; (cons (list 1 2) 3) ==> ((1 2) . 3)
; (cons 1 (list 2 3)) ==> (1 2 3)

; ex 2.23
(for-each (lambda (x)
                 (newline)
                 (display x))
          (list 57 321 88))

(define (for-each proc l)
  (proc (car l))
  (if (not (null? (cdr l)))
      (for-each proc (cdr l))
      #f))

;; 2.2.2
(cons (list 1 2) (list 3 4))

(define x (cons (list 1 2) (list 3 4)))
(length x)

(count-leaves x)

(list x x)

(length (list x x))

(count-leaves (list x x))

(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

; ex 2.24
(list 1 (list 2 (list 3 4)))

; list type
;; +---------------+     +---+--+     +---+--+
;; | (1 (2 (3 4))) | --> |   |  | --> |   |  |
;; +---------------+     +---+--+     +---+--+
;;                         |            |
;;                         |            |
;;                         v            v
;;                       +---+        +---+--+     +---+--+
;;                       | 1 |        |   |  | --> |   |  |
;;                       +---+        +---+--+     +---+--+
;;                                      |            |
;;                                      |            |
;;                                      v            v
;;                                    +---+        +---+--+     +---+--+
;;                                    | 2 |        |   |  | --> |   |  |
;;                                    +---+        +---+--+     +---+--+
;;                                                   |            |
;;                                                   |            |
;;                                                   v            v
;;                                                 +---+        +---+--+
;;                                                 | 3 |        |   |  |
;;                                                 +---+        +---+--+
;;                                                                |
;;                                                                |
;;                                                                v
;;                                                              +---+
;;                                                              | 4 |
;;                                                              +---+

; tree type?
;; +---------------+     +-----------+     +-------+     +---+
;; | (1 (2 (3 4))) | --> | (2 (3 4)) | --> | (3 4) | --> | 4 |
;; +---------------+     +-----------+     +-------+     +---+
;;   |                     |                 |
;;   |                     |                 |
;;   v                     v                 v
;; +---------------+     +-----------+     +-------+
;; |       1       |     |     2     |     |   3   |
;; +---------------+     +-----------+     +-------+

; ex 2.25

(define x (list 1 3 (list 5 7) 9))

(define y (list (list 7)))

(define z (list 1 (list 2 (list 3 (list 4 (list 5 (list 6 7)))))))

(define (find-number x n)
  (cond ((null? x) 0)
        ((not (pair? x)) (if (= x n) 1
                             0))
        (else (+ (find-number (car x) n)
                 (find-number (cdr x) n))))))

(car (cdr (car (cdr (cdr x)))))

(car (car y))

(car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr z))))))))))))

; ex 2.26

(define x (list 1 2 3))

(define y (list 4 5 6))

(append x y)
; (1 2 3 4 5 6)

(cons x y)
; ((1 2 3) 4 5 6)

(list x y)
; ((1 2 3) (4 5 6))

; ex 2.27
(define x (list (list 1 2) (list 3 4))) ; ((1 2) (3 4))
(define y (list (list 1 2) 3 4)) ; ((1 2) 3 4))
(define z (list (list (list 1 2) (list 3 4)) 5 6)) ; (((1 2) (3 4)) 5 6))

(define (deep-reverse x)
  (cond ((null? x) '())
        ((pair? (car x))
         (append (deep-reverse (cdr x)) (list (deep-reverse (car x)))))
        (else
         (append (deep-reverse (cdr x)) (list (car x))))))

;(define (deep-reverse x)
;  (cond ((null? x) '())
;        ((pair? x)
;         (if (null? (cdr x))
;             (append (deep-reverse (car x)) (list (cdr x)))
;             (append (deep-reverse (cdr x)) (deep-reverse (car x)))))
;        (else (list x))))
                    

(deep-reverse x)
(deep-reverse y)
(deep-reverse z)
(reverse x)
           
; ex 2.28
(define x (list (list 1 2) (list 3 4)))

(define (fringe x)
  (cond ((null? x) '())
        ((pair? x)
         (append (fringe (car x)) (fringe (cdr x))))
        (else (list x))))

(fringe x)

(fringe (list x x))

; ex 2.29
(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

; a.
(define (left-branch mobile)
  (car mobile))

(define (right-branch mobile)
  (car (cdr mobile)))

(define mobile1 (make-mobile (make-branch 1 10) (make-branch 1 20)))

(define (branch-length x)
  (car x))

(define (branch-structure x)
  (car (cdr x)))

; b.
(define total-weight (+ (branch-structure (left-branch mobile1))
                        (branch-structure (right-branch mobile1))))

; c.
(define (torque x)
  (* (branch-structure x) (branch-length x)))

(= (torque (left-branch mobile1)) (torque (right-branch mobile1)))

; d.
(define (make-mobile left right)
  (cons left right))

(define (make-branch length structure)
  (cons length structure))

(define (right-branch mobile)
  (cdr mobile))

(define (branch-structure x)
  (cdr x))

; tree mapping

(define (scale-tree tree factor)
  (cond ((null? tree) '())
        ((not (pair? tree)) (* tree factor))
        (else (cons (scale-tree (car tree) factor)
                    (scale-tree (cdr tree) factor)))))

(scale-tree (list 1 (list 2 (list 3 4) 5) (list 6 7)) 10)

(define (scale-tree tree factor)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (scale-tree sub-tree factor)
             (* sub-tree factor)))
       tree))

; ex 2.30

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))

(define (square-tree tree)
  (cond ((null? tree) '())
        ((not (pair? tree)) (* tree tree))
        (else (cons (square-tree (car tree))
                    (square-tree (cdr tree))))))

(define (square-tree tree)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (square-tree sub-tree)
             (* sub-tree sub-tree)))
       tree))

; ex 2.31
(define (square x) (* x x))

(define (square-tree tree) 
  (tree-map square tree))

(define (tree-map proc tree)
  (map (lambda (sub-tree)
         (if (pair? sub-tree)
             (tree-map proc sub-tree)
             (proc sub-tree)))
       tree))

; ex 2.32
(define (subsets s)
  (if (null? s)
      (list '())
      (let ((rest (subsets (cdr s))))
        (append rest (map (lambda(x) (cons (car s) x)) rest)))))

(subsets (list 1 2 3))

;1. The powerset of all the elements without the first.
;2. The powerset of all the elements without the first, with the first element prepended to each subset.

(subsets '(1))
; 1. ()
; 2. (1)

(subsets '(2))
; 1. ()
; 2. (2)

(subsets '(1 2))
; 1. () (2)
; 2. (1) (1 2)

(subsets '(2 3))
; 1. () (3)
; 2. (2) (2 3)

(subsets '(1 2 3))
; 1. () (3) (2) (2 3)
; 2. (1) (1 2) (1 3) (1 2 3)

; 2.2.3 conventional interface

(define z (list (list (list 1 2) (list 3 4)) 5 6))

(define (square x)
  (* x x))

(define (sum-odd-squares tree)
  (cond ((null? tree) 0)
        ((not (pair? tree))
         (if (odd? tree) (square tree) 0))
        (else (+ (sum-odd-squares (car tree))
                 (sum-odd-squares (cdr tree))))))

(define (fib n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib (- n 1))
                 (fib (- n 2))))))


(define (even-fibs n)
  (define (next k)
    (if (> k n)
        '()
        (let ((f (fib k)))
          (if (even? f)
              (cons f (next (+ k 1)))
              (next (+ k 1))))))
  (next 0))
              
(map square (list 1 2 3 4 5))

(define (filter predicate sequence)
  (cond ((null? sequence) '())
        ((predicate (car sequence))
         (cons (car sequence)
              (filter predicate (cdr sequence))))
        (else (filter predicate (cdr sequence)))))

(filter odd? (list 1 2 3 4 5))

(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
          (accumulate op initial (cdr sequence)))))

(accumulate + 0 (list 1 2 3 4 5))

(accumulate * 1 (list 1 2 3 4 5))

(accumulate cons '() (list 1 2 3 4 5))

(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

(enumerate-interval 2 7)

(define (enumerate-tree tree)
  (cond ((null? tree) '())
        ((not (pair? tree)) (list tree))
        (else (append (enumerate-tree (car tree))
                      (enumerate-tree (cdr tree))))))

(enumerate-tree (list 1 (list 2 (list 3 4)) 5))

(define (sum-odd-squares tree)
  (accumulate +
              0
              (map square
                   (filter odd?
                           (enumerate-tree tree)))))

(define (even-fibs n)
  (accumulate cons
              '()
              (filter even?
                      (map fib
                           (enumerate-interval 0 n)))))


(define (list-fib-squares n)
  (accumulate cons
              '()
              (map (lambda (x) (* x x))
                   (map fib
                        (enumerate-interval 0 n)))))

(list-fib-squares 10)

(define (product-of-squares-odd-elements sequence)
  (accumulate *
              1
              (map (lambda (x) (* x x))
                   (filter odd? sequence))))

(product-of-squares-odd-elements (list 1 2 3 4 5))

(define (salary-of-highest-paid-programmer records)
  (accumulate max
              0
              (map salary
                   (filter programmer? records)

; ex 2.33
(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) '() sequence))

(map (lambda (x) (+ x 1)) (list 1 2 3 4 5))

(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

(append (list 1 2 3 4 5) (list 6 7 8 9 10))

(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

(length (list 1 2 3 4 5))

; ex 2.34
(define (horner-eval x coefficient-sequence)
  (accumulate (lambda (this-coeff higher-terms) (+ (* higher-terms x) this-coeff))
              0
              coefficient-sequence))

(horner-eval 2 (list 1 3 0 5 0 1))
; 79
((lambda (x) (+ 1 (* 3 x) (* 5 (* x x x)) (* x x x x x))) 2)
; 79

; ex 2.35
(define x (cons (list 1 2) (list 3 4)))

(define y (cons (cons (list 1 2) (list 3 4)) (cons (list 5 6) (list 7 8))))

(define (count-leaves x)
  (cond ((null? x) 0)
        ((not (pair? x)) 1)
        (else (+ (count-leaves (car x))
                 (count-leaves (cdr x))))))

(define (count-leaves t)
  (accumulate +
              0 
              (map (lambda (seq)
                     (if (pair? seq) (accumulate (lambda (x y) (+ 1 y)) 0 seq)
                         1))
                   t)))

;; (define (count-leaves t)
;;   (accumulate (lambda (x y) (+ 1 y))
;;               0
;;               (map (lambda (seq)
;;                      (if (pair? seq) (enumerate-tree t)
;;                          seq))
;;                    t)))

;; (define (count-leaves t)
;;   (accumulate (lambda (x y) (+ 1 y))
;;               0
;;               (map enumerate-tree t)))

(count-leaves x)
(count-leaves y)

; ex 2.36
(define s (list (list 1 2 3) (list 4 5 6) (list 7 8 9) (list 10 11 12)))

;; (define (pick seq)
;;   (if (null? seq)
;;       '()
;;       (cons (car (car seq)) (pick (cdr seq)))))

;; (define (pick2 seq)
;;   (if (null? seq)
;;       '()
;;       (cons (cdr (car seq)) (pick2 (cdr seq)))))

;; (pick s)
;; (pick2 s)

(accumulate cons '() (map car s))
(accumulate cons '() (map cdr s))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      '()
      (cons (accumulate op init (accumulate cons '() (map car seqs)))
            (accumulate-n op init (accumulate cons '() (map cdr seqs))))))

(accumulate-n + 0 s)

; ex 2.37

(define m (list (list 1 2 3 4) (list 5 6 7 8) (list 9 10 11 12)))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

;; (define (matrix-*-vector m v)
;;   (map 
;;    (lambda (seq) 
;; ;     (display (cons seq (list v)))
;; ;     (newline)
;;      (accumulate-n * 1 (cons seq (list v)))) m))

(define (matrix-*-vector m v)
  (map 
   (lambda (seq) 
     (accumulate + 0 
                 (accumulate-n * 1 (cons seq (list v))))) m))

(matrix-*-vector m (list 1 2 3 4))

;; 1 2 3  a    1a + 2b + 3c
;; 4 5 6  b  = 4a + 5b + 6c
;; 7 8 9  c    7a + 8b + 9c

(define (transpose mat)
  (accumulate-n cons '() mat))

;; ((1 2 3) (4 5 6) (7 8 9))
;; ==> ((1 4 7) (2 5 8) (3 6 9))

(transpose m)

;; 1 2 3  a b c    
;; 4 5 6  d e f  = 
;; 7 8 9  g h i

(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map 
     (lambda (v) (matrix-*-vector cols v)) m)))

(define m1 (list (list 1 2 3) (list 4 5 6) (list 7 8 9)))
(define m2 (list (list 7 8 9) (list 4 5 6) (list 1 2 3)))

;; by wolfram alpha 
;; 3(6 | 8 | 10
;; 18 | 23 | 28
;; 30 | 38 | 46) 

(matrix-*-vector m1 (list 7 8 9))
(matrix-*-matrix m1 m2)

;; ((18 24 30) (54 69 84) (90 114 138))

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
        result
        (iter (op result (car rest))
              (cdr rest))))
  (iter initial sequence))

(define (fold-right op initial sequence)
  (accumulate op initial sequence))

(fold-right / 1 (list 1 2 3))
; 3/2
(fold-left / 1 (list 1 2 3))
; 1/6
(fold-right list '() (list 1 2 3))
; (((() 1) 2) 3)
(fold-left list '() (list 1 2 3))
; (((() 1) 2) 3)
    
; ex 2.39
(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) '() sequence))

(reverse (list 1 2 3 4))

(define (reverse sequence)
  (fold-left (lambda (x y) (append (list y) x)) '() sequence))

;; nested mapping
(define (pairmap n)
  (accumulate append
              '()
              (map (lambda (i)
                     (map (lambda (j) (list i j))
                          (enumerate-interval 1 (- i 1))))
                   (enumerate-interval 1 n))))

(pairmap 10)

(define (square n)
  (* n n))

(define (smallest-divisor n)
  (define (divides? a b)
    (= (remainder b a) 0))
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
	  ((divides? test-divisor n) test-divisor)
	  (else (find-divisor n (+ test-divisor 1)))))
  (find-divisor n 2))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
               (flatmap
                (lambda (i)
                  (map (lambda (j) (list i j))
                       (enumerate-interval 1 (- i 1))))
                (enumerate-interval 1 n)))))

(prime-sum-pairs 10)

(define (permutations s)
  (if (null? s)
      (list '())
      (flatmap (lambda (x)
                 (map (lambda (p) (cons x p))
                      (permutations (remove x s))))
               s)))

(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
          sequence))

(permutations (list 1 2 3))

; ex 2.40
(define (unique-pairs n)
  (flatmap
   (lambda (i)
     (map (lambda (j) (list i j))
          (enumerate-interval 1 (- i 1))))
   (enumerate-interval 1 n)))

(unique-pairs 10)

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum? (unique-pairs n))))

(prime-sum-pairs 10)

; ex 2.41
(define (triples n)
  (flatmap
   (lambda (i)
     (flatmap (lambda (j)
            (map (lambda (k) (list i j k))
                 (enumerate-interval 1 (- j 1))))
          (enumerate-interval 1 (- i 1))))
   (enumerate-interval 1 n)))

(triples 10)
  

; ex 2.42
(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
        (list empty-board)
        (filter
         (lambda (positions) (safe? k positions))
         (flatmap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (enumerate-interval 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))

(define (adjoin-position new-row k rest-of-queens)
  (display new-row)
  (display ",")
  (display k)
  (display ",")
  (display rest-of-queens))

(define empty-board '())

(queens 4)