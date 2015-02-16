#lang scheme

(require test-engine/scheme-tests)

(define mmap
  (lambda (f xs)
    (if (empty? xs)
        '()
        (cons (f (first xs)) 
              (mmap f (rest xs))))))

(define ffoldr
  (lambda (f id xs)
    (if (empty? xs)
        id
        (f (first xs) (ffoldr f id (rest xs))))))

(define norm-sq
  (lambda (xs)
    (if (empty? xs)
        0
        (+ (* (first xs) (first xs))
           (norm-sq (rest xs))))))

(check-expect (norm-sq '(1 2 3)) 
              (ffoldr + 0 (mmap (lambda (x) (* x x)) '(1 2 3))))

; prove that for all lists L:
; (norm-sq L) = (ffoldr + 0 (mmap (lambda (x) (* x x)) L))

(test)
