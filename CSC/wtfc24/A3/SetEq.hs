module SetEq where

import Set

instance Eq s => Eq (Set s) where
	(Set []) == (Set []) = True
	(Set b) == (Set []) = False
	(Set []) == (Set b) = False
	(Set a) == (Set b) = (subset a b) && ((length a) == (length b))
