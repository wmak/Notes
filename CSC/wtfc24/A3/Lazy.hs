module Lazy where

{- triples' is the infinite version of triples -}
triples' = [(x, y, x*x+y*y) | z <- [1..] ,y <-[1..z], x <- [1..y], x*x+y*y==z*z]
triples' :: [(Integer, Integer, Integer)]
{- cycle' will generatean infinitely repeating list of numbers from 0 to n-1.-}
cycle' n = [x | y <- [0..], x <- [0..n-1]]
cycle' :: (Num t, Enum t) => t -> [t]
{- geom takes two numbers a and r and will return an infinite geometric
 - sequence [a, ar^2, ar^3...] -}
geom a r = [a*r^k | k <- [0..]]
geom :: Num a => a -> a -> [a]
