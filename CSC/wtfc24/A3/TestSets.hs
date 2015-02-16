module TestSets where

import Test.HUnit

import Set
import SetShow
import SetEq
import POrd
import SetPOrd

{- Starter -- Test Set functionality -}

testEq  = TestCase $ assertEqual
          "{1, 2, 3} == {2, 3, 1} is " True
          (s == s')

testShow  = TestCase $ assertEqual
            "show {42} is" "{42}"
            (show singleton)

testOrd  = TestCase $ assertEqual
           "{1, 2, 3} `lt` {2, 3, 1, 4} is " True
           (s `lt` t)

tests = TestList [TestLabel "testEq" testEq,
                  TestLabel "testShow" testShow,
                  TestLabel "testOrd" testOrd
                 ]
main = runTestTT tests
