-- write a function that given a common ratio r and a scalar factor a,
-- returns an (infinite) geometric sequence
-- (look up geometic sequences on wikipedia, if you don't remember 
-- how they are defined)

gseq x r = iterate (*r) x

-- can you use this function to compute the sum of an infinite
-- geometric sequence?

sumg xs n = sum (take n xs)

-- recall our datatype for binary trees
data BTree a = Empty | Node a (BTree a) (BTree a)

t = Node 10 (Node 5 (Node 2 Empty Empty)
                    (Node 7 (Node 6 Empty Empty) Empty))
            (Node 15 Empty (Node 20 Empty Empty))

-- we want to be able to print BTrees as follows (tilt your head to
-- the left!)
--     20
--  15
--10
--    7
--      6
--  5
--    2
-- let's make it happen.

ptree Empty = []
ptree (Node x left right) = (map (" "++) (ptree left)) ++ [show x] ++ (map (" "++) (ptree right))
printTree t = mapM_ putStrLn (reverse (ptree t))

-- we now want to be able to compare BTrees for equality. We say that two
-- BTrees are equal if they contain the same elements. The shape of the
-- trees does not determine whether the trees are equal.

t' = Node 7 (Node 5 (Node 2 Empty Empty)
                    (Node 6 Empty Empty))
            (Node 15 (Node 10 Empty Empty) 
                     (Node 20 Empty Empty))
-- want t == t'
-- let's make it happen.

ctree Empty = []
ctree (Node x left right) = (ctree left) ++ [x] ++ (ctree right)

compareTree t1 t2 = (ctree t1) == (ctree t2)

-- now look up generators in Python. Can you rewrite the geometric
-- sequence function in Python?
-- df gseqn(x, r, n):
-- 	num = 0
-- 	while num != n:
-- 	 yield x
-- 	 x *= r
-- 	 num += 1
