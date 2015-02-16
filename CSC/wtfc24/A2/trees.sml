(* Binary trees in ML *)

datatype 'a tree = Leaf of 'a | Node of 'a * 'a tree * 'a tree;

fun tfold f g (Leaf x) = f x
  | tfold f g (Node (x, left, right)) = 
    g (x, (tfold f g left), (tfold f g right));
tfold: ('a -> 'b) -> ('a * 'b * 'b -> 'b) -> 'a tree -> 'b;

(* countNodes will return the number of nodes in a given tree *)
fun countNodes (Node (x, left, right)) = 
  1 + countNodes left + countNodes right
  | countNodes (Leaf(a)) = 1;

countNodes: 'a tree -> int;

(* forAllNodes that takes a predicate and a tree and returns true if and only if
* all the nodes of a given tree satisfy the predicate *)
fun forallNodes p (Node (x, left, right)) =
  p x andalso forallNodes p left andalso forallNodes p right
  | forallNodes p (Leaf(a)) = p a; 

forallNodes: ('a -> bool) -> 'a tree -> bool;

(* existsNode that takes a predicate and a tree and returns ture if and only if
* at least one node of the given tree satisfies the predicate *)
fun existsNode p (Node (x, left, right)) =
  p x orelse existsNode p left orelse existsNode p right
  | existsNode p (Leaf(a)) = p a;

existsNode: ('a -> bool) -> 'a tree -> bool;

(*  inorder that returns a list corresponding to the in-order traversal of the
*  given tree *)
fun inorder (Node (x, left, right)) =
  inorder left @ [x] @ inorder right
  | inorder (Leaf(a)) = [a];

inorder: 'a tree -> 'a list;

(* countNodes written using tfold *)
fun countNodes' t = tfold (fn x => 1) (fn (x,y,z) => 1+y+z) t;

countNodes': 'a tree -> int; 

(* forallNodes written using tfold *)
fun forallNodes' p t = tfold p (fn (x,y,z) => (p x) andalso y andalso z) t;

forallNodes': ('a -> bool) -> 'a tree -> bool;

(* existsNode witten using tfold *)
fun existsNode' p t = tfold p (fn (x,y,z) => (p x) orelse y orelse z) t;

existsNode': ('a -> bool) -> 'a tree -> bool;

(* inorder written using tfold *)
fun inorder' t = tfold (fn x => [x]) (fn (x,y,z) => y @ [x] @ z) t;

inorder': 'a tree -> 'a list;

(* A linear-time tail-recursive version of inorder *)
fun inorderLinearTail (Node(x, left, right)) lst = 
  inorderLinearTail left ([x]@lst)  @ inorderLinearTail right []
  | inorderLinearTail (Leaf(x)) lst = [x] @ lst;
fun inorderLinear t = inorderLinearTail t [];

inorderLinearTail: 'a tree -> 'a list -> 'a list;
inorderLinear: 'a tree -> 'a list;

val t = Node (10,
        Node(5,
       Leaf(2),
       Leaf(7)),
        Node(15, 
       Leaf(12),
       Node(20, 
      Leaf(17),
      Node(25,
           Leaf(23),
           Leaf(30)))));

countNodes t = 11 andalso
forallNodes (fn x => x > 0) t andalso
existsNode (fn x => x = 17) t andalso
inorder t = [2, 5, 7, 10, 12, 15, 17, 20, 23, 25, 30];(* andalso
inorderLinear t = [2, 5, 7, 10, 12, 15, 17, 20, 23, 25, 30];
countNodes' t = 11 andalso
forallNodes' (fn x => x > 0) t andalso
existsNode' (fn x => x = 17) t andalso
inorder' t = [2, 5, 7, 10, 12, 15, 17, 20, 23, 25, 30];
*)
