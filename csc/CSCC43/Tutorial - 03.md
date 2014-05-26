# Question
1) conseider the relation shown below
* list all the FDs that this relation instance satisfies
* Assume that the attribute value Z of the last record in the relation is
	  changed from Z<sub>3</sub> to Z<sub>2</sub>. List all the FDs that this
	  relation instance satisfies

|  X  |  Y  |  Z  | 
| --- | --- | --- |
| x_1 | y_1 | z_1 |
| x_1 | y_1 | z_2 |
| x_2 | y_1 | z_1 |
| x_2 | y_1 | z_3 |

# Answer
* X -> Y, Z -> Y, XZ -> Y
* It's the same after the change.	

# Question
2) suppose that we have the following 3 tuples in a legal instance of a relation
S with 3 attributes ABC:
* (1, 2, 3)
* (4, 2, 3)
* (5, 2, 3)
* Which of the following dependencies can you infer does not hold over
  Schema S? 
	* A) A -> B: No
	* B) BC -> A: Yes
	* C) B -> C: No
* Can you identify any dependies that hold over S?
	* No, because you only have tuples
