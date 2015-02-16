(module diff scheme
 ; a Scheme procedure (differentiate expr var), which takes two arguments:
 ; ﬁrst, the formula to be differentiated (in the list representation 
 ; described above); and second, the variable with respect to which the
 ; differentiation will be done, as a symbol. The function will return the 
 ; partial derivative, also in the list representation.
 (define (differentiate expr var)
  (if (list? expr)
   (cond
    ; first two rules, addition and subtractions
    ((or (equal? (first expr) '+) (equal? (first expr) '-))
     (map
      (lambda (value)
       (differentiate value var)
      )
     expr)
    )
    ; multiplication rule
    ((equal? (first expr) '*)
     (list '+
      (list '* (list-ref (rest expr) 1) (differentiate (car (rest expr)) var)) 
      ;using list-ref cause cdr returns a single entry list
      (list '* (car (rest expr)) (differentiate (list-ref (rest expr) 1) var))
     )
    )
    ; division rule
    ((equal? (first expr) '/)
     (list '/
      (list '-
       (list '* (list-ref (rest expr) 1) (differentiate (car (rest expr)) var))
       ;using list-ref cause cdr returns a single entry list
       (list '* (car (rest expr)) (differentiate (list-ref (rest expr) 1) var))
      )
      (list '*
       (list-ref (rest expr) 1)
       (list-ref (rest expr) 1)
      )
     )
    )
    ; cosine rule + chain rule (since cos/sin are the only functions)
    ((equal? (first expr) 'cos)
     (list '*
      (list '-
       0
       (list 'sin (first (rest expr)))
      )
      (differentiate (first (rest expr)) var)
     )
    )
    ; sine rule + chain rule (since cos/sin are the only functions)
    ((equal? (first expr) 'sin)
     (list '*
      (list 'cos (first (rest expr)))
      (differentiate (first (rest expr)) var)
     )
    )
    (else 
     "unknown!!!" 
     ; three exclamation marks incase unknown appears from another message
    )
   )
   ; if the expression is the variable (ie dx/dx) then return 1,
   ; otherwise return 0 since it's a constant
   (if (equal? expr var)
    1
    (if (not (member expr (list '+ '- '*)))
     0
     expr
    )
   )
  )
 )
 (provide differentiate)
)
