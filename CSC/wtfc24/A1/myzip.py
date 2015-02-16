'''(my-zip-rec xs ys) -> list
xs, ys: lists of same length
return a list of pairs of corresponding elements from xs and ys
e.g., my_zip([1,2],[3,4]) ==> [[1,3], [2,4]]
implement this function recursively'''
def my_zip_rec(xs, ys):
	if len(xs) == len(ys):
		if xs == []:
			return []
		else:
			final = [[xs[0], ys[0]]]
			final.extend(my_zip_rec(xs[1:], ys[1:]))
			return final
	else:
		return "Error"

'''non-recursive version'''
def my_zip(xs, ys):
	if len(xs) == len(ys):
		final = []
		for i in range(len(xs)):
			final.append([xs[i], ys[i]])
		return final
	else:
		return "Error"