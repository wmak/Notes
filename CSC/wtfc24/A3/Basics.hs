module Basics where

{- numNeg takes in a list xs and returns the number of negative numbers -}
numNeg xs = length [(i) | i<-xs, i<0] 
numNeg :: Integral t => [t] -> Int
{- genSquares will generate a list of squares of all the even numbers from a
 - given lower limit low to an upper limit high -}
genSquares low high = [(i*i) | i <- [low..high],mod i 2==0]
genSquares :: Integral t => t -> t -> [t]
{- triples will create a list of positive integer triples (x, y, z) all less
 - than or equal to n, such that x^2+y^2 = z^2. -}
triples n = [(x, y, z) | 
			x <- [1..n], 
			y <- [x..n], 
			z <- [1..n],
			x*x+y*y==z*z
			]
triples :: Integral t => t -> [(t, t, t)]

