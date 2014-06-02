# Lecture 05

## Relational Algebra
* Consists of primitive operators.
* Union
* Interection
* Difference
* Projection
	* Unary operator
	* uses symbol pi
	* π(R) : given a relationship R if you project a set of attribute, and
	  reduces it to that
	* ie. if you start with (title, year, length) and you project
	  π<sub>title</sub> you would only get title in the result.
* Selection
	* Unary operator
	* uses symbol sigma
	* σ(R) : given a condition returns all results where it's true
* Cartesian product.
	* Pairs each tuple t<sub>1</sub> of R<sub>1</sub> with each tuple
	  t<sub>2</sub> of R<sub>2</sub> 
* Theta joiin
	* result is all combinations of tuples in R and S that satisfy the relation
	  θ 
	* equivalent to: R θ S = σ<sub>θ</sub>(R × S)
* Natural join
	* Similar to theta join, but attributes of the same name are equated.
* Operator Precedence
	* Unary first
	* next highest are mutiplicative
	* Lowest are the additive like union, intersection, and difference.
