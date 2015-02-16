#lang scheme

(require test-engine/scheme-tests)
(require "func-basics.ss")

; testing my-zip
(check-expect (my-zip '(1 2) '(3 4)) '((1 . 3) (2 . 4)))
(check-expect (my-zip '(1 1 1 1) '(2 3 4 5)) '((1 . 2) (1 . 3) (1 . 4) (1 . 5)))
(check-expect (my-zip '(1 1 1 1) '(2 2 2 2)) '((1 . 2) (1 . 2) (1 . 2) (1 . 2)))
(check-expect (my-zip '((1) (1) (1) (1)) '(2 3 4 5)) '(((1) . 2) ((1) . 3) ((1) . 4) ((1) . 5)))
(check-expect (my-zip '((1 2) (2 3) (3 4) (4 5)) '(2 3 4 5)) '(((1 2) . 2) ((2 3) . 3) ((3 4) . 4) ((4 5) . 5)))
(check-expect (my-zip '((1 2) (2 3) (3 4) (4 5)) '((2 3) (3 4) (4 5) (5 6))) '(((1 2) . (2 3)) ((2 3) . (3 4)) ((3 4) . (4 5)) ((4 5) . (5 6))))
(check-expect (my-zip '() '()) '())
; testing my-zip recursive
(check-expect (my-zip-rec '(1 2) '(3 4)) '((1 . 3) (2 . 4)))
(check-expect (my-zip-rec '(1 1 1 1) '(2 3 4 5)) '((1 . 2) (1 . 3) (1 . 4) (1 . 5)))
(check-expect (my-zip-rec '(1 1 1 1) '(2 2 2 2)) '((1 . 2) (1 . 2) (1 . 2) (1 . 2)))
(check-expect (my-zip-rec '((1) (1) (1) (1)) '(2 3 4 5)) '(((1) . 2) ((1) . 3) ((1) . 4) ((1) . 5)))
(check-expect (my-zip-rec '((1 2) (2 3) (3 4) (4 5)) '(2 3 4 5)) '(((1 2) . 2) ((2 3) . 3) ((3 4) . 4) ((4 5) . 5)))
(check-expect (my-zip-rec '((1 2) (2 3) (3 4) (4 5)) '((2 3) (3 4) (4 5) (5 6))) '(((1 2) . (2 3)) ((2 3) . (3 4)) ((3 4) . (4 5)) ((4 5) . (5 6))))
(check-expect (my-zip-rec '() '()) '())

; setup for compose-all
(define inc (lambda (x) (+ x 1)))
(define double (lambda (x) (* x 2)))

; testing compose-all
(check-expect ((compose-all (list inc)) -2) -1)
(check-expect ((compose-all (list abs inc)) -2) 1)
(check-expect ((compose-all (list abs inc)) -5) 4)
(check-expect ((compose-all (list abs double double)) -2) 8)
(check-expect ((compose-all (list abs double double inc)) -2) 4)
(check-expect ((compose-all (list inc double inc)) -2) -1)
; test the recursive ones too
(check-expect ((compose-all-rec (list inc)) -2) -1)
(check-expect ((compose-all-rec (list abs inc)) -2) 1)
(check-expect ((compose-all-rec (list abs inc)) -5) 4)
(check-expect ((compose-all-rec (list abs double double)) -2) 8)
(check-expect ((compose-all-rec (list abs double double inc)) -2) 4)
(check-expect ((compose-all-rec (list inc double inc)) -2) -1)

; tests for alt-sum
(check-expect (alt-sum '(1 2 3 4 5)) 3)
(check-expect (alt-sum '()) 0)
(check-expect (alt-sum '(1)) 1)
(check-expect (alt-sum '(-1 2 -3 4 -5)) -15)

(test)