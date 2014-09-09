## Question 1
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

* X -> Y, Z -> Y, XZ -> Y
* It's the same after the change.	

## Question 2
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

3) Scheme: CSJDPQV
* FDs:
	* C -> CSJDPQV
	* JP -> C
	* SD -> D
* Prove that JP and SDJ are super key

1. C -> CSJDPQV
* JP -> C
* SD -> D
* JP -> CSJDPQV (trans 1,2), this gives us that JP is a super key
* SDJ -> PJ (Aug 3)
* SDJ -> CSJDPQV (trans 5,4), this gives us that SDJ is a superkey

4) 
* Prove that AD -> E, FD:
	1. A -> C
	* CD -> AE
	* BE -> A
	* AE -> E
	* AD -> CD (aug 1)
	* AD -> AE (trans 2,5)
	* AD -> E (trans 4,6)

5)
* Prove X -> WYZ, FD:
	1. X -> YZ
	* Z -> W
	* X -> Z
	* X -> W (trans 2,3)
	* X -> YZX (aug 1) [XX -> X]
	* XYZ -> WYZ (aug 4)
	* X -> WYZ (trans 5,6)

