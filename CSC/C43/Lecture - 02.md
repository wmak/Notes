# Lecture 02

## ER modelling
* Triangle = a subclass relationship.
* Underline = A key.
	* Keys are also inherited.
* Double rectangle/diamond = _weak_ entity set
	* A weak set is when the keys come from other entity sets that it is linked
	  to.
* Dashed box = Aggregate
* Don't allow multiple inheritance to avoid the problems that come with that

## Keys
* **Minimal Key**: A key with as few attributes possible
* **Superkey**: !MinimalKey.
* With n attributes, and k keys what is the maximum number of super keys
  that you can have?
	* 2<sup>n-k</sup>

## The Relational Model
