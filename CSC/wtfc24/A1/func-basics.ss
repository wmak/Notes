(module func-basics scheme
	
	; (my-zip-rec xs ys) -> list
	; xs, ys: lists of same length
	; return a list of pairs of corresponding elements from xs and ys
	; e.g., (my-zip-rec '(1 2) '(3 4)) ==> ((1 . 3) (2 .4))
	; implement this function recursively
	(define (my-zip-rec xs ys)
		(if (equal? (length xs) (length ys))
			(if (empty? xs) ; since xs and ys are the same length, if xs is empty then ys is empty, and return the empty list
				'()
				(cons 
					(cons (first xs) (first ys)) ; construct a pair from first element of each list
					(my-zip-rec (rest xs) (rest ys) ) ; append the recursively created pairs
				)
			)
			("Error"); if the lengths of input don't equal
		)
	)

	; non-recursive version
	(define (my-zip xs ys)
		(if (equal? (length xs) (length ys)) ; check that the inputs are the same length
			(map 
				(lambda (i)
					(cons (list-ref xs i) (list-ref ys i)) ; construct a pair from the ith value of each list
				)
			(build-list (length xs) values)) ; run a map over the length of the inputs
			("Error")
		)
	)
	
	; (compose-all-rec fs) -> procedure 
	; fs: listof procedure
	; return the function composition of all functions in fs:
	; if fs = (f0 f1 ... fN), the result is f0(f1(...(fN(x))...))
	; implement this procedure recursively
	(define (compose-all-rec fs)
		(if (equal? (length fs) 1) ; if the list has only one function return it
			(first fs)
			(lambda (x)
				((first fs) ((compose-all-rec (rest fs)) x)) ; otherwise have the first function call the rest.
			)
		)
	)
	
	; the non-recursive version. Use foldr.
	(define (compose-all fs)
		(lambda (x) ; create an anonymous function
			(foldr 
				(lambda (func val)
					(func val) ; call on the current function the value.
				) x ; the initial value will be the x passed to the overall function
			fs)
		)
	)
	
	; (alt-sum xs) -> number
	; xs: listof number
	; return the result of the alternating sum of elements of xs
	; i.e., (alt-sum '(a b c d e ...)) returns the value of
	;   a - b + c - d + e ... 
	; (alt-sum '()) is 0 
	; implement this function non-recursively. Use foldr.
	(define (alt-sum xs)
		(foldr
			+
			0
		(map
			(lambda (i)
				(if (even? i)
					(list-ref xs i)
					(- 0 (list-ref xs i))
				)
			)
		(build-list (length xs) values)))
	)	
	(provide my-zip-rec my-zip compose-all-rec compose-all alt-sum)
)