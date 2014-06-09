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
	* π<sub>sname</sub>(σ colour = "red"(part) ⋈ Catalog) ⋈ Supplier
	* π<sub>sid</sub>(σ colour = "red" v color = "green" (part) ⋈ Catalog)
	* π<sub>sid</sub>((σ colur= "red"(part) ⋈ Catalog) U π<sub>sid</sub>(σ
	  colour = "green" "(part) ⋈ Catalog))
* Find the name of the Suppliers from 40 St Street and supplies red parts
	* π<sub>sid</sub>(σ address = "40 St Street (Supplier)) ∩ 
      π<sub>sid</sub>(σ colour = "red" (part) ⋈ Catalog)
* Find pairs of suppliers, such that the first supplier charges more for a part
  than the second supplier in the pair.
	* Create a second catalog using the rename function
	* π<sub>sid</sub>(Catalog1 ⋈<sub>θ</sub> Catalog2)
	* θ = catalog1.pid = catalog2.pid ∧ catalog1.cost > catalog2.cost
* Find the suppliers that supply all the parts.
	* π<sub>sid, pid</sub>(Catalog) / π<sub>pid</sub>(part)
