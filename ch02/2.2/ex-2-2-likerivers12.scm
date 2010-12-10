;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Ch 2 데이터를 요약해서 표현력을 끌어올리는 방법
;;; Ch 2.2 계층 구조 데이터와 닫힘 성질

;;;;=================<ch 2.2.1 차례열의 표현 방법>=====================
;;; p129

(define one-through-four (list 1 2 3 4))

;;; p130
(car one-through-four)
;; 1

(cdr one-through-four)
;; (2 3 4)

(car (cdr one-through-four))
;; 2

(cons 10 one-through-four)
;; (10 1 2 3 4)

(cons 5 one-through-four)
;; (5 1 2 3 4)

;;;-----------------------------
;;; 리스트 연산 
;;; p131

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))

(define squares (list 1 4 9 16 25))

(list-ref squares 3)
;; 16


(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

(define odds (list 1 3 5 7))

(length odds)
;; 4

;;; 반복하는 length
(define (length items)
  (define (length-iter a count)
    (if (null? a)
	count
	(length-iter (cdr a) (+ 1 count))))
  (length-iter items 0))

(length odds)
;; 4

(append squares odds)
;; (1 4 9 16 25 1 3 5 7)

(append odds squares)
;; (1 3 5 7 1 4 9 16 25)


;;; 되도는 append 정의
(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))

(append squares odds)
;; (1 4 9 16 25 1 3 5 7)

(append odds squares)
;; (1 3 5 7 1 4 9 16 25)

;;;--------------------------< ex 2.17 >--------------------------
;;; p133

(define (last-pair lst)
  (if (null? lst)
      '()
      (if (null? (cdr lst))
	  lst
	  (last-pair (cdr lst)))))

(last-pair (list 23 72 149 34))
;; (34)

(last-pair (list 1))
;; (1)

(last-pair '())
;; ()

;;;--------------------------< ex 2.18 >--------------------------
;;; p133

(define (reverse lst)
  (define (reverse-iter lst2 acc)
    (if (null? lst2)
	acc
	(reverse-iter (cdr lst2) (cons (car lst2) acc))))
  (reverse-iter lst '()))

(reverse (list 1 4 9 16 25))
;; (25 16 9 4 1)


;;;--------------------------< ex 2.19 >--------------------------
;;; 동전 바꾸기 다시 보기
;;; p133,4

(define us-coins (list 50 25 10 5 1))

(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(define (cc amount coin-values)
  (cond ((= amount 0) 1)
	((or (< amount 0) (no-more? coin-values)) 0)
	(else
	 (+ (cc amount
		(except-first-denomination coin-values))
	    (cc (- amount
		   (first-denomination coin-values))
		coin-values)))))


(define (first-denomination coin-values)
  (car coin-values))

(define (except-first-denomination coin-values)
  (cdr coin-values))

(define (no-more? coin-values)
  (null? coin-values))

(cc 100 us-coins)
;; 292

(define us-coins (reverse (list 50 25 10 5 1)))

(cc 100 us-coins)
;; 292
;; 리스트 원소의 차례가 cc 프로시저의 결과에 영향을 주는가?
;; : 영향을 주지 않는다.
;;   coin-values 안에 있는 동전의 종류를 모두 고려하는데,
;;   리스트 원소의 순서가 바뀌는 것은 방법을 따져보는 순서가 바뀌는 것 뿐이다.


;;;--------------------------< ex 2.20 >--------------------------
;;; p134,5,6

(define (f x y . z) (list x y z))

(f 1 2 3 4 5 6)
;; (1 2 (3 4 5 6))

(define (g . w) w)

(g 1 2 3 4 5 6)
;; (1 2 3 4 5 6)

(define (same-parity . lst)
  (define (same-parity-inner predicate lst2)
    (if (null? lst2)
	'()
	(let ((el (car lst2)))
	  (if (predicate (car lst2))
	      (cons el (same-parity-inner predicate (cdr lst2)))
	      (same-parity-inner predicate (cdr lst2))))))
  (if (null? lst)
      '()
      (if (even? (car lst))
	  (same-parity-inner even? lst)
	  (same-parity-inner odd? lst))))

(same-parity 1 2 3 4 5 6 7)
;; (1 3 5 7)

(same-parity 2 3 4 5 6 7)
;; (2 4 6)

(same-parity )
;; ()

(same-parity 1 2 4 6)
;; (1)



;;;-----------------------------
;;; 리스트 매핑(mapping)
;;; p136

(define (scale-list items factor)
  (if (null? items)
      '() ;nil
      (cons (* (car items) factor)
	    (scale-list (cdr items) factor))))

(scale-list (list 1 2 3 4 5) 10)
;; (10 20 30 40 50)

;;; p137
(define (map proc items)
  (if (null? items)
      '() ;nil
      (cons (proc (car items))
	    (map proc (cdr items)))))

(map abs (list -10 2.5 -11.6 17))
;; (10 2.5 11.6 17)

(map (lambda (x) (* x x))
     (list 1 2 3 4))
;; (1 4 9 16)


(define (scale-list items factor)
  (map (lambda (x) (* x factor))
       items))

(scale-list (list 1 2 3 4 5) 10)
;; (10 20 30 40 50)


;;;--------------------------< ex 2.21 >--------------------------
;;; p138
(define (square-list items)
  (if (null? items)
      '()
      (cons (square (car items))
	    (square-list (cdr items)))))

;;;---
(define (square x)
  (* x x))
;;;---

(square-list (list 1 2 3 4))
;; (1 4 9 16)

(define (square-list items)
  (map (lambda (x) (square x)) items))

(square-list (list 1 2 3 4))
;; (1 4 9 16)


;;;--------------------------< ex 2.22 >--------------------------
;;; p138
;;; 반복하는 square-list

(define (square-list items)
  (define (iter things answer)
    (if (null? things)
	answer
	(iter (cdr things)
	      (cons (square (car things))
		    answer))))
  (iter items '())) ;;nil))

(square-list (list 1 2 3 4))
;; (16 9 4 1)

(cons (square 2) (cons (square 1) '()))  ; ...
;; items에서 뒤쪽에 있는 원소가 answer의 앞쪽에 cons된다.
;; [ + | + ]               <- 2)
;;   |   | 
;;   2   |
;;     [ + | + ]           <- 1)
;;       |   |
;;       1  nil


(define (square-list items)
  (define (iter things answer)
    (if (null? things)
	answer
	(iter (cdr things)
	      (cons answer
		    (square (car things))))))
  (iter items '()))

(square-list (list 1 2 3 4))
;; '((((() . 1) . 4) . 9) . 16)

;;; 1. (cons answer (...)) 에서 answer 가 atom이 아니라 cons cell 이다.
;;; 2. (cons answer (...)) 에서 (...)가 cons cell 이 아니라 atom 이다.
(cons '(1) 2)
;; ((1) . 2)


;;;; 수행 단계 분석
;; 1)
(cons '() 1)
;; [ + | + ]  <- new cons cell
;;   |   |
;;  nil  1
;;
;;-> (() . 1)

;; 2)
(define ans '(() . 1))

(cons ans 4)
;; [ + | + ] <- new cons cell
;;   |   |
;;  ans  4 
;;
;; => [ + | + ]
;;      |   |   
;;      |   4
;;      |
;;    [ + | + ]         <- ans
;;      |   |
;;     nil  1
;;
;;-> '((() . 1) . 4)

;; 3) 
(define ans '((() . 1) . 4))

(cons ans 9)
;; '(((() . 1) . 4) . 9)


;;; 원하는대로 답이 나오게 하려면
;;; a) 매번 list에 대한 append를 수행
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
	answer
	(iter (cdr things)
	      (append answer
		      (list (square (car things)))))))
  (iter items '()))

(square-list (list 1 2 3 4))
;; (1 4 9 16)

(append (append (append (append '() (list 1)) (list 4)) (list 9)) (list 16))
;;                      ^^^^^^^^^^^^^^^^^^^^^
;;                             1) - (1)
;;              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;;                             2) - (1 4)
;;      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;;                             3) - (1 4 9)
;;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;;                             4) - (1 4 9 16)

;;; b) 첫번째 방식으로 풀고 최종결과를 reverse
(define (square-list items)
  (define (iter things answer)
    (if (null? things)
	answer
	(iter (cdr things)
	      (cons (square (car things))
		    answer))))
  (let ((res (iter items '())))
    (reverse res)))

(square-list (list 1 2 3 4))
;; (1 4 9 16)

;;;--------------------------< ex 2.23 >--------------------------
;;; p139

;; 풀이 1)
(define (for-each proc items)
  (if (null? items)
      '()
      (begin
	(proc (car items))
	(for-each proc (cdr items)))))

(for-each (lambda (x) (newline) (display x))
	  (list 57 321 88))
;; 57
;; 321
;; 88

;; 풀이 2)
(define (for-each proc items)
  (if (null? items)
      '()
      (let ((tmp (proc (car items))))
	(for-each proc (cdr items)))))

(for-each (lambda (x) (newline) (display x))
	  (list 57 321 88))
;; 57
;; 321
;; 88

;;;;=================<ch 2.2.2 계층 구조법>=====================
;;; p139
(cons (list 1 2) (list 3 4))
;; ((1 2) 3 4)

(define x (cons (list 1 2) (list 3 4)))

(length x)
;; 3

(define (count-leaves x)
  (cond ((null? x) 0)
	((not (pair? x)) 1)
	(else (+ (count-leaves (car x))
		 (count-leaves (cdr x))))))

(count-leaves x)
;; 4

(list x x)
;; '(((1 2) 3 4) ((1 2) 3 4))

(length (list x x))
;; 2

(count-leaves (list x x))
;; 8



;;;--------------------------< ex 2.24 >--------------------------
;;; p142
(list 1 (list 2 (list 3 4)))  ;에 대한 나무꼴
;; (1 (2 (3 4)))
;;=>
;; [ + | + ]-->[ + | / ]  
;;   |           | 
;;   1         [ + | + ]-->[ + | / ]
;;               |           |
;;               2         [ + | + ]--[ + | / ]
;;                           |          |
;;                           3          4

;;;--------------------------< ex 2.25 >--------------------------
;;; p142,3
;;; 7을 꺼집어 내려면
(car (cdaddr '(1 3 (5 7) 9)))
;; 7

(caar '((7)))
;; 7

(cadadr (cadadr (cadadr '(1 (2 (3 (4 (5 (6 7)))))))))
;; 7

;;;--------------------------< ex 2.26 >--------------------------
;;; p143

(define x (list 1 2 3))

(define y (list 4 5 6))

(append x y)
;; (1 2 3 4 5 6)

(cons x y)
;; ((1 2 3) 4 5 6)

(list x y)
;; ((1 2 3) (4 5 6))

;;;--------------------------< ex 2.27 >--------------------------
;;; p143,4

;; 리스트가 아닌 경우에도 가능하도록 list인지 여부를 확인하는 내용을 추가함
(define (reverse items)
  (define (reverse-iter items2 acc)
    (if (list? items2)
	(if (null? items2)
	    acc
	    (reverse-iter (cdr items2) (cons (car items2) acc)))
	items2))
  (reverse-iter items '()))

(reverse '(1 2 3 4))
;; (4 3 2 1)

(reverse 1)
;; 1

(reverse '(1 . 2))
;; (1 . 2)

(reverse '(1 (2 . 3)))
;; ((2 . 3) 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 풀이 1)
;; 인자가 항상 2 단계의 리스트라면 아래와 같이 해도 된다.
(define (deep-reverse items)
  (reverse (map reverse items)))

(deep-reverse '(1 2 3 4))
;; (4 3 2 1)

(deep-reverse '((1 2) (3 4)))
;; ((4 3) (2 1))

;; 그러나! 이 방법에서는 3단계 이상의 리스트에 대해서 내부의 순서를 바꾸지 못한다.
(deep-reverse '((1 2) (3 (4 5))))
;;-> (((4 5) 3) (2 1))
;; (((5 4) 3) (2 1)) 이 바른 답임.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 바른 풀이
(define (deep-reverse items)
  (cond ((null? items) '())
	((list? items) (reverse (map deep-reverse items)))
	(else items)))

(deep-reverse '(1 2 3 4))
;; (4 3 2 1)

(deep-reverse '((1 2) (3 4)))
;; ((4 3) (2 1))

(deep-reverse '((1 2) (3 (4 5))))
;; (((5 4) 3) (2 1))

(deep-reverse 1)
;; 1

(deep-reverse '(1 . 2))
;; (1 . 2)   <- 리스트가 아니므로 맞는 결과임.

(deep-reverse '(1 2 (3 4 (5 6)) 7 8 (9 . 10)))
;; ((9 . 10) 8 7 ((6 5) 4 3) 2 1)


(define x (list (list 1 2) (list 3 4)))

x
;; ((1 2) (3 4))

(reverse x)
;; ((3 4) (1 2))

(deep-reverse x)
;; ((4 3) (2 1))

;;;--------------------------< ex 2.28 >--------------------------
;;; p144

;; 풀이 1)
(define (fringe items)
  (cond ((null? items) '())
	((list? items) (append (fringe (car items)) (fringe (cdr items))))
	(else (list items))))

(fringe '(1 2 3 4))
;; (1 2 3 4)

(fringe '((1 2) (3 4)))
;; (1 2 3 4)

(fringe '(1 2 (3 4 (5 6) 7) 8 9 (10 . 11) 12))
;; (1 2 3 4 5 6 7 8 9 (10 . 11) 12)

(define x (list (list 1 2) (list 3 4)))
x
;; ((1 2) (3 4))

(fringe x)
;; (1 2 3 4)

(fringe (list x x))
;; (1 2 3 4 1 2 3 4)


;;----------------------------------
;; 여러가지 시도...

;; 아래와 같이 하면..
(define (fringe items)
  (cond ((null? items) '())
	((list? items) (cons (fringe (car items)) (fringe (cdr items))))
	(else (list items))))
;;==
(define (fringe items)
  (cond ((null? items) '())
	((list? items) (append (map fringe items)))
	(else (list items))))

(fringe '(1 2 3 4))
;; ((1) (2) (3) (4))

(fringe '((1 2) (3 4)))
;; (((1) (2)) ((3) (4)))

(fringe '(1 2 (3 4 (5 6) 7) 8 9 (10 . 11) 12))
;; ((1) (2) ((3) (4) ((5) (6)) (7)) (8) (9) ((10 . 11)) (12))

;; 유사..
(define (fringe items)
  (cond ((null? items) '())
	((list? items) (cons (fringe (car items)) (cons (fringe (cdr items)) '())))
	(else items)))


(fringe '(1 2 3 4))
;; '(1 (2 (3 (4 ()))))

(fringe '((1 2) (3 4)))
;; '((1 (2 ())) ((3 (4 ())) ()))

(fringe '(1 2 (3 4 (5 6) 7) 8 9 (10 . 11) 12))
;; '(1 (2 ((3 (4 ((5 (6 ())) (7 ())))) (8 (9 ((10 . 11) (12 ())))))))

;;;--------------------------< ex 2.29 >--------------------------
;;; p144,5

(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

;;-------------------------------------------------
;; a) - 모빌에서 가지를 골라내는 고르개 정의
;;    - 가지의 구성요소를 골라내는 고르개
(define (left-branch mbl)
  (car mbl))

(define (right-branch mbl)
  (cadr mbl))

(define (branch-length brch)
  (car brch))

(define (branch-structure brch)
  (cadr brch))

;;;--------------------------
;;; 테스트                
;;                       m0
;;                        *
;;                        |
;;                m1      |        m2
;;                 *-=----+----=---*
;;                 |               |
;;          m3     |  s4       m5  |       m6 
;;             *---+---6        *--+----=--*
;;             |                |          |
;;          s7 |  s8     s9     |  s10  s11|  s12
;;           4-+--2       2=----+--5    1--+--1


(define s12 1)
(define b12 (make-branch 2 s12))

(define s11 1)
(define b11 (make-branch 2 s11))

(define s10 5)  ;(define s10 4))
(define b10 (make-branch 2 s10))

(define s9 2)
(define b9 (make-branch 5 s9))

(define s8 2)
(define b8 (make-branch 2 s8))

(define s7 4)
(define b7 (make-branch 1 s7))

(define m6 (make-mobile b11 b12))
(define b6 (make-branch 7 m6))

(define m5 (make-mobile b9 b10))
(define b5 (make-branch 2 m5))

(define s4 6)
(define b4 (make-branch 3 s4))

(define m3 (make-mobile b7 b8))
(define b3 (make-branch 3 m3))

(define m2 (make-mobile b5 b6))
(define b2 (make-branch 8 m2))

(define m1 (make-mobile b3 b4))
(define b1 (make-branch 6 m1))

(define m0 (make-branch b1 b2))

m0 
;; '((6 ((3 ((1 4) (2 2))) (3 6))) (8 ((2 ((5 2) (2 5))) (7 ((2 1) (2 1))))))

m5
;; '((5 2) (2 5))

s10
;; 5

s4
;; 6

(left-branch m5)  ; '(5 2)
(right-branch m5) ; '(2 5)

(branch-length (right-branch m5)) ; 2
(branch-structure (right-branch m5)) ; 5

;;-------------------------------------------------
;; b) 모빌의 전체 무게

(define (total-weight m)
  (if (mobile? m)
      (let ((left (left-branch m))
	    (right (right-branch m)))
	(+ (total-branch-weight left)
	   (total-branch-weight right)))
      m))

(define (total-branch-weight b)
  (let ((len (branch-length b))
	(s (branch-structure b)))
    (if (mobile? s) 
	(total-weight s)
	s)))

(define (mobile? s)
  (if (pair? s)
      #t
      #f))

(total-weight m1) ;; 12 

(total-weight m2) ;; 9

(total-weight m0) ;; 21

(total-weight s10) ;; 5

;;-------------------------------------------------
;; c) 균형 잡힌 상태
;;  1) 왼쪽 맨 윗가지의 돌림힘 = 오른쪽 맨 윗가지의 돌림힘
;;     돌림힘 = (막대 길이) * (막대에 매달린 추 무게 합)
;;  2) 가지마다 매달린 모든 부분 모빌도 균형 잡힌 상태

(define (mobile-torque m)
  (if (mobile? m)
      (let ((lb (left-branch m))
	    (rb (right-branch m)))
	(cons (branch-torque lb)
	      (branch-torque rb)))
      0))

(define (branch-torque b)
  (* (total-branch-weight b) 
     (branch-length b)))

(define (mobile-balanced? m)
  (if (mobile? m)
      (let ((lb (left-branch m))
	    (rb (right-branch m)))
	(and (= (branch-torque lb) (branch-torque rb))
	     (branch-balanced? lb)
	     (branch-balanced? rb)))
      #t))

(define (branch-balanced? b)
  (if (pair? b)
      (let ((s (branch-structure b)))
	(if (mobile? s)
	    (mobile-balanced? s)
	    #t))
      #t))

(mobile-torque m0)     ;; (72 . 72)

(mobile-balanced? m0)  ;; #t

(mobile-torque m1)     ;; (18 . 18)

(mobile-balanced? m1)  ;; #t

(mobile-torque m2)     ;; (14 . 14)

(mobile-balanced? m2)  ;; #t

(mobile-torque m6)     ;; (2 . 2)

(mobile-balanced? m6)  ;; #t

(mobile-torque s10)    ;; 0

(mobile-balanced? s10) ;; #t

s4 ;; 6

m1 ;;'((3 ((1 4) (2 2))) (3 6))

;; 모빌 수정
(define s4 4) ;; <------------ 6에서 4로 수정
(define b4 (make-branch 3 s4))

(define m3 (make-mobile b7 b8))
(define b3 (make-branch 3 m3))

(define m2 (make-mobile b5 b6))
(define b2 (make-branch 8 m2))

(define m1 (make-mobile b3 b4))
(define b1 (make-branch 6 m1))

(define m0 (make-branch b1 b2))

s4 ;; 4

(mobile-torque s4)    ;; 0 

;;!!!!!
(mobile-balanced? s10) ;; #t

;;;
(mobile-torque m0)     ;; (60 . 72)

(mobile-balanced? m0)  ;; #f

(mobile-torque m1)     ;; (18 . 12)

(mobile-balanced? m1)  ;; #f

(mobile-torque m2)     ;; (14 . 14)

(mobile-balanced? m2)  ;; #t

(mobile-torque m6)     ;; (2 . 2)

(mobile-balanced? m6)  ;; #t

(mobile-torque s10)    ;; 0

(mobile-balanced? s10) ;; #t

;;-------------------------------------------------
;; d) 짜맞추개를 바꾸면 지금까지 짠 프로그램을 얼마나 손봐야하나?

(define (make-mobile left right)
  (cons left right))

(define (make-branch length structure)
  (cons length structure))

;;;----------------------
;;; 수정 필요
(define (right-branch mbl)
  (cdr mbl)) ; <- cadr

(define (branch-structure brch)
  (cdr brch)) ; <- cadr
;;;----------------------




;;; 나무 매핑
;;; p145

(define (scale-tree tree factor)
  (cond ((null? tree) '())
	((not (pair? tree)) (* tree factor))
	(else (cons (scale-tree (car tree) factor)
		    (scale-tree (cdr tree) factor)))))

(scale-tree (list 1 (list 2 (list 3 4) 5) (list 6 7))
	    10)
;; (10 (20 (30 40) 50) (60 70))

;;; map 이용
(define (scale-tree tree factor)
  (map (lambda (sub-tree)
	 (if (pair? sub-tree)
	     (scale-tree sub-tree factor)
	     (* sub-tree factor)))
       tree))

(scale-tree (list 1 (list 2 (list 3 4) 5) (list 6 7))
	    10)
;; (10 (20 (30 40) 50) (60 70))

;;;--------------------------< ex 2.30 >--------------------------
;;; p146,7

;;;---
(define (square x) (* x x))

;; 곧 바로 정의
(define (square-tree tree)
  (cond ((null? tree) '())
	((not (pair? tree)) (square tree))
	(else
	 (cons (square-tree (car tree))
	       (square-tree (cdr tree))))))

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))
;; 입력 : '(1 (2 (3 4) 5) (6 7))
;; 결과 : '(1 (4 (9 16) 25) (36 49))

;; map과 재귀를 써서 정의
(define (square-tree tree)
  (map (lambda (sub-tree)
	 (if (pair? sub-tree)
	     (square-tree sub-tree)
	     (square sub-tree)))
       tree))

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))
;; '(1 (4 (9 16) 25) (36 49))

;;;--------------------------< ex 2.31 >--------------------------
;;; p147

(define (tree-map proc tree)
  (map (lambda (sub-tree)
	 (if (pair? sub-tree)
	     (tree-map proc sub-tree)
	     (proc sub-tree)))
       tree))

(define (square-tree tree) (tree-map square tree))

(square-tree
 (list 1
       (list 2 (list 3 4) 5)
       (list 6 7)))
;; '(1 (4 (9 16) 25) (36 49))


;;;--------------------------< ex 2.32 >--------------------------
;;; p147

(define (subsets s)
  (if (null? s)
      (list '())
      (let ((rest (subsets (cdr s))))
	(append rest (map <??> rest)))))

(subsets '(1 2 3))