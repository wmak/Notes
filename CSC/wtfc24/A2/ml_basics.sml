(* Some ML functions, to get ourselves used to programming in ML. *)

(* A test is a pair (predicate, its name). *)
datatype 'a test = Test of ('a -> bool) * string;

(* given xs and ys return a list of alternating elements of xs and ys so that
 * elements from each list are in the same relative order *)
fun interleave ([], []) = []
  | interleave ([], c::d) = interleave([], [])
  | interleave (a::b, []) = interleave([], [])
  | interleave (a::b, c::d) = a :: c :: interleave(b,d);

interleave: 'a list * 'a list -> 'a list;

(* repeat n f x produces a list of length n + 1, where the first element of the
 * list is x and each succesive element is obtained by applying f to the 
 * previous element.
 *)
fun repeat 0 f x = [x]
  | repeat n f x = x :: repeat (n-1) f (f(x));

repeat: int -> ('a -> 'a) -> 'a -> 'a list;

(* Given a value x and a list of tests of test pairs, return a list of names of
 * all the tests from tests that x passes.
 *)
fun pass x [] = []
  | pass x (Test(tst,str)::t) = 
  if (tst(x)) then [str] @ (pass x t)
  else pass x t;

pass: 'a -> 'a test list -> string list; 

(* non recursive version of pass *)
fun pass' a p = (map(fn Test(tst,str) => str)
  (List.filter (fn Test(tst,str) => tst(a)) p));
 
pass': 'a -> 'a test list -> string list; 

(*revpass is a helper function for all pass, returns true if the test passes on
all values of a *)
fun revpass a (Test(tst,str)) = List.all (fn x => tst(x)) a;

(* given a list of values and a list of tests returns a list of tests that are
satisfied by all values in the first list. *)
fun allPass a p = List.filter (revpass a) p; 

revpass: 'a list -> 'a test -> bool;
allPass: 'a list -> 'a test list -> 'a test list;

(* the sanity checks *)

fun interleaveSC () = 
    (interleave ([1, 2, 3], [4, 5]) = [1, 4, 2, 5]) andalso
    (interleave ([1, 2, 3], [4, 5, 6]) = [1, 4, 2, 5, 3, 6]);

fun inc x = x + 1;
fun twice x = x * 2;
fun repeatSC () =
    (repeat 0 inc 42 = [42]) andalso
    (repeat 5 twice 1 = [1, 2, 4, 8, 16, 32]);

val pos = Test (fn x => x > 0, "pos");
val even = Test (fn x => x mod 2 = 0, "even");
val small = Test (fn x => x < 100, "small");

fun passSC () =
    (pass 42 [] = []) andalso
    (pass ~101 [pos, even, small] = ["small"]);

fun passSC' () =
    (pass' 42 [] = []) andalso
    (pass' ~101 [pos, even, small] = ["small"]);

fun names xs = map (fn Test(_, name) => name) xs;
fun allPassSC () =
    (names(allPass [] [pos, even]) = ["pos", "even"]) andalso
    (names(allPass [1, 2, 40, 150] [pos, even, small]) =
     ["pos"]);

interleaveSC() andalso repeatSC() andalso passSC() andalso passSC'()
