import java.util.LinkedList;

class MyZip {
	public static LinkedList myZipRec(LinkedList xs, LinkedList ys){
		if (xs.size() == ys.size()){
			if (xs.size() == 0){
				return xs;
			} else {
				LinkedList result = new LinkedList();
				LinkedList temp = new LinkedList();
				temp.add(xs.pop());
				temp.add(ys.pop());
				result.add(temp);
				result.addAll(myZipRec(xs, ys));
				return result;
			}
		}
		throw new Error();
	}

	public static LinkedList myZip(LinkedList xs, LinkedList ys){
		if (xs.size() == ys.size()){
			LinkedList result = new LinkedList();
			for (int i=0; i<xs.size()+1; i++){			
				LinkedList temp = new LinkedList();
				temp.add(xs.pop());
				temp.add(ys.pop());
				result.add(temp);
			}
			return result;
		}
		throw new Error();
	}
}
