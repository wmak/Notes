# Lecture 06

## Division operator
* Non primitive
* A relation with two fields x,y and a second relation with only y.
	* A/B = {x | exists x,y in A forall y in b}
* ie.
	* A has sno, pno
	* B has sno.
	* This means the output of A/B = {sno, s1, s2, s3}

## Examples
* Supplier(sid, sname, address)
* Part(pid, pname, colour)
* Catalog(sid, pid, cost)
* Find the names of the suppliers that supply atleast one red part.
	* π<sub>sname</sub>(σ = "red"(part) (join⋈) Catalog) (join⋈) Supplier
