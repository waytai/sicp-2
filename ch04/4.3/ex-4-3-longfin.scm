;; 4.3 Variations on a Scheme -- Nondeterministic Computing

(define (prime-sum-pair list1 list2)
  (let ((a (an-element-of list1))
		(b (an-element-of list2)))
	(require (prime? (+ a b)))
	(list a b)))

(define (prime? x)
  (define (iter n)
	(cond ((= n x) #t)
		  ((= (remainder x n) 0) #f)
		  (else
		   (iter (+ 1 n)))))
  (if (< x 2)
	  #f
	  (iter 2)))

;; 4.3.1 Amb and Search


(define-syntax amb
  (syntax-rules ()
    ((amb) (try-again))
    ((amb x) x)
    ((amb x . xs)
     (amb+ (lambda () x)
           (lambda () (amb . xs))))))

(define (try-again)
  (if (null? amb-stack)
      (error "amb search tree exhausted")
      (let ((r (car amb-stack)))
        (set! amb-stack (cdr amb-stack))
        (r))))

(define (amb-reset)
  (set! amb-stack '()))
      
(define amb-stack '())

(define (amb+ a b)
  (define s '())
  (set! s amb-stack)
  (call/cc
   (lambda (r)
     (call/cc
      (lambda (c)
        (set! amb-stack 
              (cons c amb-stack))
        (r (a))))
	 (set! amb-stack s)
     (b))))  

(define call/cc call-with-current-continuation)


(list (amb 1 2 3) (amb 'a 'b))

(try-again)

(define (require p)
  (if (not p) (amb)))

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))


;; Driver loop

;; ;;; Amb-Eval input:
;; (prime-sum-pair '(1 3 5 8) '(20 35 110))
;; ;;; Starting a new problem
;; ;;; Amb-Eval value:
;; (3 20)
;; ;;; Amb-Eval input:
;; try-again
;; ;;; Amb-Eval value:
;; (3 110)
;; ;;; Amb-Eval input:
;; try-again
;; ;;; Amb-Eval value:
;; (8 35)
;; ;;; Amb-Eval input:
;; try-again
;; ;;; There are no more values of
;; (prime-sum-pair (quote (1 3 5 8)) (quote (20 35 110)))
;; ;;; Amb-Eval input:
;; (prime-sum-pair '(19 27 30) '(11 36 58))
;; ;;; Starting a new problem ;;; Amb-Eval value: (30 11)

;; ex 4.35

(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high)))
	(let ((j (an-integer-between i high)))
	  (let ((k (an-integer-between j high)))
		(require (= (+ (* i i) (* j j)) (* k k)))
		(list i j k)))))

(define (an-integer-between low high)
  (require (not (> low high)))
  (amb low (an-integer-between (+ 1 low) high)))

;; ex 4.36

;; replacing an-integer-between by an-integer-starting-from...

(define (a-pythagorean-triple)
  (let ((i (an-integer-starting-from 1)))
	(let ((j (an-integer-starting-from i)))
	  (let ((k (an-integer-starting-from j)))
		(require (= (+ (* i i) (* j j)) (* k k)))
		(list i j k)))))

;; it goes to infinite loop because (try-again) produces only k.(continuation of k is top of amb-stack)

;; 1^2 + 1^2 vs 1^2
;; 1^2 + 1^2 vs 2^2
;; 1^2 + 1^2 vs 3^2
;; 1^2 + 1^2 vs 4^2
;; 1^2 + 1^2 vs 5^2
;; ...

(define (a-pythagorean-triple)
  (let ((k (an-integer-starting-from 1)))
	(let ((i (an-integer-between 1 k)))
	  (let ((j (an-integer-between 1 i)))
		(require (= (+ (* i i) (* j j)) (* k k)))
		(list i j k)))))

;; 1^2 + 1^2 vs 1^2
;; 1^2 + 1^2 vs 2^2
;; 2^2 + 1^2 vs 2^2
;; 2^2 + 2^2 vs 2^2
;; 1^2 + 1^2 vs 3^2
;; ...


;; ex 4.37
(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high))
		(hsq (* high high)))
	(let ((j (an-integer-between i high)))
	  (let ((ksq (+ (* i i) (* j j))))
		(require (>= hsq ksq))
		(let ((k (sqrt ksq)))
		  (require (integer? k))
		  (list i j k))))))

;; hsq = high * high
;; ksq = i^2 + j^2
;; filter hsq >= ksq
;; filter sqrt ksq(=k) is integer

;; (a-pythagorean-triple-between 1 10)

;; high = 10
;; low = 1

;; [amb-1]
;; i = 1

;; hsq = 100

;; [amb-2]
;; j = 1
;; ksq = 2

;; require 100 >= 2
;; k = sqrt 2

;; require k is integer => false : to amb-2

;; [amb-2]
;; j == i :to amb-1

;; [amb-1]
;; i = 2

;; hsq = 100

;; [amb-2]
;; j = 1
;; ksq = 5

;; require 100 >= 5
;; k = sqrt 5

;; require k isn't integer => false : to amb-2

;; ...


;; it uses only 2 continuation.(i, j) so time complexity is O(n^2)[4.35's solution is O(n^3)]

;; 4.3.2 Examples of Nondeterministic Programs

;; Logic Puzzles

(define (distinct? list)
  (define (find el lst)
	 (cond
	  ((null? lst) #f)
	  ((= el (car lst)) #t)
	  (else (find el (cdr lst)))))		  
  (cond ((null? list) #t)
		((= 1 (length list)) #t)
		(else
		 (if (find (car list) (cdr list))
			 #f
			 (distinct? (cdr list))))))
(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
		(cooper (amb 1 2 3 4 5))
		(fletcher (amb 1 2 3 4 5))
		(miller (amb 1 2 3 4 5))
		(smith (amb 1 2 3 4 5)))
	(require
	 (distinct? (list baker cooper fletcher miller smith)))
	(require (not (= baker 5)))
	(require (not (= cooper 1)))
	(require (not (= fletcher 5)))
	(require (not (= fletcher 1)))
	(require (> miller cooper))
	(require (not (= (abs (- smith fletcher)) 1)))
	(require (not (= (abs (- fletcher cooper)) 1)))
	(list (list 'baker baker)
		  (list 'cooper cooper)
		  (list 'fletcher fletcher)
		  (list 'miller miller)
		  (list 'smith smith))))


;; ex 4.38

		  
(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5))
		(cooper (amb 1 2 3 4 5))
		(fletcher (amb 1 2 3 4 5))
		(miller (amb 1 2 3 4 5))
		(smith (amb 1 2 3 4 5)))
	(require
	 (distinct? (list baker cooper fletcher miller smith)))
	(require (not (= baker 5)))
	(require (not (= cooper 1)))
	(require (not (= fletcher 5)))
	(require (not (= fletcher 1)))
	(require (> miller cooper))
;;	(require (not (= (abs (- smith fletcher)) 1)))
	(require (not (= (abs (- fletcher cooper)) 1)))
	(list (list 'baker baker)
		  (list 'cooper cooper)
		  (list 'fletcher fletcher)
		  (list 'miller miller)
		  (list 'smith smith))))

;; > (multiple-dwelling)
;; ((baker 1) (cooper 2) (fletcher 4) (miller 3) (smith 5))
;; > (try-again)
;; ((baker 1) (cooper 2) (fletcher 4) (miller 5) (smith 3))
;; > (try-again)
;; ((baker 1) (cooper 4) (fletcher 2) (miller 5) (smith 3))
;; > (try-again)
;; ((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
;; > (try-again)
;; ((baker 3) (cooper 4) (fletcher 2) (miller 5) (smith 1))
;; > (try-again)
;; ((baker 1) (cooper 2) (fletcher 4) (miller 3) (smith 5))
;; > (try-again)
;; ((baker 1) (cooper 2) (fletcher 4) (miller 5) (smith 3))


;; ex 4.39

;; Ordering condition doesn't effect whole time complexity.(it's effected only # of branches), but if all predicate on condition aren't same, ordering condition can effect performance...(if (distinct?) costs more than '=, checking '= first is efficient way.)


;; ex 4.40

(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5)))
	(require (not (= baker 5)))
	(let (cooper (amb 1 2 3 4 5))
	  (require (not (= cooper 1)))
	  (let (fletcher (amb 1 2 3 4 5))
		(require (not (= fletcher 5)))
		(require (not (= fletcher 1)))
		(let ((miller (amb 1 2 3 4 5))
			  (smith (amb 1 2 3 4 5)))
		  (require
		   (distinct? (list baker cooper fletcher miller smith)))
		  (require (> miller cooper))
		  (require (not (= (abs (- smith fletcher)) 1)))
		  (require (not (= (abs (- fletcher cooper)) 1)))
		  (list (list 'baker baker)
				(list 'cooper cooper)
				(list 'fletcher fletcher)
				(list 'miller miller)
				(list 'smith smith)))))))

;; ex 4.41

(define (multiple-dwelling2)
  (let ((*answer* '()))
	(let ((baker '(1 2 3 4 5)))
	  (for-each (lambda (b)
				  (let ((copper '(1 2 3 4 5)))
					(for-each (lambda (c)
								(let ((fletcher '(1 2 3 4 5)))
								  (for-each (lambda (f)
											  (let ((miller '(1 2 3 4 5)))
												(for-each (lambda (m)
															(let ((smith '(1 2 3 4 5)))
															  (for-each (lambda (s)
																		  (let ((result (list b c f m s)))
																			(if (distinct? result)
																				(if (not (= b 5))
																					(if (not (= c 1))
																						(if (and (not (= f 5))
																								 (not (= f 1)))
																							(if (> m c)
																								(if (not (= (abs (- s f)) 1))
																									(if (not (= (abs (- f c)) 1))
																										(set! *answer* result))))))))))
																		smith)))
														  miller)))
											fletcher)))
							  copper))
				  baker)))
	*answer*))
  


;; ex 4.42

(define (solve-lairs)
  (let ((betty (amb 1 2 3 4 5))
		(ethel (amb 1 2 3 4 5))
		(kitty (amb 1 2 3 4 5))
		(joan (amb 1 2 3 4 5))
		(mary (amb 1 2 3 4 5)))
	(require (distinct? (list betty
							  ethel
							  kitty
							  joan
							  mary)))
	(require (or (and (= kitty 2) (not (= betty 3)))
				 (and (not (= kitty 2)) (= betty 3))))
	(require (or (and (= ethel 1) (not (= joan 2)))
				 (and (not (= ethel 1)) (= joan 2))))
	(require (or (and (= joan 3) (not (= ethel 5)))
				 (and (not (= joan 3)) (= ethel 5))))
	(require (or (and (= kitty 2) (not (= mary 4)))
				 (and (not (= kitty 2)) (= mary 4))))
	(require (or (and (= mary 4) (not (= betty 1)))
				 (and (not (= mary 4)) (= betty 1))))

	(list (list 'betty betty)
		  (list 'ethel ethel)
		  (list 'kitty kitty)
		  (list 'joan joan)
		  (list 'mary mary))))

;; ex 4.43
(define (distinct? list)
  (define (find el lst)
	(let ((pred (if (symbol? el) eq? =)))
	  (cond
	   ((null? lst) #f)
	   ((pred el (car lst)) #t)
	   (else (find el (cdr lst))))))
  (cond ((null? list) #t)
		((= 1 (length list)) #t)
		(else
		 (if (find (car list) (cdr list))
			 #f
			 (distinct? (cdr list))))))

(define (who-is-lornas-father)
  (let ((mary (amb 'moore 'downing 'hall 'hood 'parker)))
;;	(require (eq? mary 'moore))
	(let ((gabrielle (amb 'moore 'downing 'hall 'hood 'parker))
		  (lorna (amb 'moore 'downing 'hall 'hood 'parker))
		  (rosalind (amb 'moore 'downing 'hall 'hood 'parker))
		  (melissa (amb 'moore 'downing 'hall 'hood 'parker)))
	  (require (distinct? (list mary gabrielle lorna rosalind melissa)))
	  (require (not (eq? gabrielle 'hood))) ;; hood
	  (require (not (eq? lorna 'moore))) ;; moore
	  (require (not (eq? rosalind 'hall))) ;; hall
	  (require (eq? melissa 'hood)) ;; downing
	  lorna)))

;; ex 4.44

(define (solve-eight-queens)
  (let ((q1 (amb 1 2 3 4 5 6 7 8))
		(q2 (amb 1 2 3 4 5 6 7 8))
		(q3 (amb 1 2 3 4 5 6 7 8))
		(q4 (amb 1 2 3 4 5 6 7 8))
		(q5 (amb 1 2 3 4 5 6 7 8))
		(q6 (amb 1 2 3 4 5 6 7 8))
		(q7 (amb 1 2 3 4 5 6 7 8))
		(q8 (amb 1 2 3 4 5 6 7 8)))
	(require (distinct? (list q1 q2 q3 q4 q5 q6 q7 q8)))
	(require (distinct? (list (- q1 1)
	 						  (- q2 2)
	 						  (- q3 3)
							  (- q4 4)
							  (- q5 5)
							  (- q6 6)
							  (- q7 7)
							  (- q8 8))))
	(require (distinct? (list (+ q1 1)
							  (+ q2 2)
							  (+ q3 3)
							  (+ q4 4)
							  (+ q5 5)
							  (+ q6 6)
							  (+ q7 7)
							  (+ q8 8))))
	(list q1 q2 q3 q4 q5 q6 q7 q8)))
	
			

	  