module TestBasics where

import Basics
import Test.HUnit

{- Starter -- Test Basics -}

xs1 = [1, -2, -3, -4, 42, -5]
xs2 = [1, 2, 3, 4, 42, 5]
xs3 = [-3, -1, -4, -5]
xs4 = []

testNumNegNorm = TestCase $ assertEqual
			("numNeg [1, -2, -3, -4, 42, -5] is ") 4
			(numNeg xs1)

testNumNegNone = TestCase $ assertEqual
			("numNeg [1, 2, 3, 4, 42, 5] is") 0
			(numNeg xs2)

testNumNegAll = TestCase $ assertEqual
			("numNeg [-3, -1, -4, -5] is") 4
			(numNeg xs3)

testNumNegEmpty = TestCase $ assertEqual
			("numNeg [] is") 0
			(numNeg xs4)

testGenSquaresLowIsHigh = TestCase $ assertEqual
			("GenSquares 5 5 is") []
			(genSquares 5 5)

testGenSquaresSmall = TestCase $ assertEqual
			("GenSquares 1 2 is") [4]
			(genSquares 1 2)

testGenSquaresNormal = TestCase $ assertEqual
			("GenSquares 1 10 is") [4, 16, 36, 64, 100]
			(genSquares 1 10)

testTriplesZero = TestCase $ assertEqual
			("triples 0 is") []
			(triples 0)

testTriplesSingle = TestCase $ assertEqual
			("triples 5 is") [(3,4,5)]
			(triples 5)

testTriplesNormal = TestCase $ assertEqual
			("triples 15 is") [(3,4,5),(5,12,13),(6,8,10),(9,12,15)]
			(triples 15)

tests = TestList [
				TestLabel "numNegNorm" testNumNegNorm,
				TestLabel "numNegNone" testNumNegNone,
				TestLabel "numNegAll" testNumNegAll,
				TestLabel "numNelEmpty" testNumNegEmpty,
				TestLabel "genSquaresLowIsHigh" testGenSquaresLowIsHigh,
				TestLabel "genSquaresSmall" testGenSquaresSmall,
				TestLabel "genSquaresNormal" testGenSquaresNormal,
				TestLabel "TriplesZero" testTriplesZero,
				TestLabel "TriplesSingle" testTriplesSingle,
				TestLabel "TriplesNormal" testTriplesNormal
				]

main = runTestTT tests
