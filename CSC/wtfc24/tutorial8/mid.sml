Control.Print.printDepth := 50;

(* Question 2b
*  * plot abs (fn x => x + 42) [1, 2, 3]; *)


(* Question 2c
*  * plot' abs (fn x => x + 42) [1, 2, 3]; *)

(* Question 2e *)

(* Question 4 *)
datatype 'a tree = Leaf of 'a
     | Node of 'a forest
          and 'a forest = Empty
                             | Trees of 'a tree * 'a forest;

