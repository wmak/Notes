#lang scheme

(require test-engine/scheme-tests)

; Question 2a
; [plot f g xs] -> listof pairs
; f, g: function
; xs: list
; Given functions f and g, and a list (x0 x1 ... xn) return the
; list of pairs (((f x0) . (g x0)) ((f x1) . (g x1)) ... ((f xn) . (g xn))).
(define (plot f g xs)
  (map
	(lambda (x)
	  (cons (f x) (g x))
	)
  xs)
)

(check-expect (plot abs (lambda (x) (+ x 42)) '(1 -2 3))
              '((1 . 43) (2 . 40) (3 . 45)))

; Question 2d
; (tree-map f xs) -> list
; Return the result of applying f to every element of xs,
; including all sublists, on every nesting level.
(define (tree-map f xs)
  (if (list? xs)
	(map
	  (lambda (x)
		(tree-map f x)
	  )
	xs)
	(f xs)
  )
)

(check-expect (tree-map abs '()) '())
(check-expect (tree-map abs '(1 2 -3)) '(1 2 3))
(check-expect (tree-map abs '(-1 (2 -3) (-4 (((-5))) -6 7) -8))
             '(1 (2 3) (4 (((5))) 6 7) 8))               


(test)
