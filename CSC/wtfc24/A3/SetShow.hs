module SetShow where

import Set

instance Show s => Show (Set s) where
	show (Set s) = "{" ++ init (tail (show s)) ++ "}"
