#lang scheme

(require test-engine/scheme-tests)


; (eval-poly x poly) -> number
; x: number
; poly: list of number
;  Given a non-empty list of numbers poly (a0 a1 a2 a3 ...)
;  return the value a0 + a1*x + a2*x^2 + a3*x^3 + ...
; The implementation should be tail-recursive, should only make
; use of * and + math operations, and should perform at most 2*n
; multiplications and n additions on an input of size n.
(define (eval-poly x poly)
	(eval-poly-tail x poly 0 0)
)

(define (eval-poly-tail x poly sum power)
	(if (empty? poly)
		sum
		(if (equal? power 0)
			(eval-poly-tail x (rest poly) (+ sum (first poly)) x)
			(eval-poly-tail x (rest poly) (+ sum (* (first poly) power)) (* power x))
		)
	)
)

(check-expect (eval-poly 5 '(6 2 3)) 91)
(check-expect (eval-poly 5 '(6)) 6)


; define a tail-recursive linear-time version of map (a simplified version
; that works on one list)
; Your solution should only traverse the input list once.
(define (map-tail proc lst)
	(map-tail-helper proc lst '())
)

(define (map-tail-helper proc lst res)
	(if (empty? lst)
		res
		(map-tail-helper proc (rest lst) (append res (list (proc (first lst)))))
	)
)
(check-expect (map-tail abs '(1 -2 3 -4 -5 -6)) '(1 2 3 4 5 6))

; define a tail-recursive linear-time version of filter
; Your solution should only traverse the input list once.
(define (filter-tail pred lst)
	(filter-tail-helper pred lst '())
)

(define (filter-tail-helper pred lst res)
	(if (empty? lst)
		res
		(if (pred (first lst))
			(filter-tail-helper pred (rest lst) (append res (list (first lst))))
			(filter-tail-helper pred (rest lst) res)
		)
	)
)

(check-expect (filter-tail positive? '(1 -2 3 -4 -5 -6)) '(1 3))

(test)
