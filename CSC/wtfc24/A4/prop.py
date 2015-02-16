def remove_bracket(s): 
    '''(str) -> String 
    return a substring of s which is the string within the outermost brackets
    ie "arstarstarst(neoneioneio)" -> "(neoneioneio)"
    '''

    pos_open = s.find("(") 
    pos_closed = s.rfind(")") 
    if pos_open and pos_closed and pos_closed > pos_open:
        return s[pos_open + 1 : pos_closed] 
    return s

def atom(s): 
    '''(str) -> bool 
    returns true if the first character is lowercase and the the entire string
    is alphanumeric
    '''

    if len(s) > 0:
        return s[0].islower() and s.isalnum() 
    return False

def formula_list(s): 
    '''(str) -> bool 
    given a list return true if each element is a formula
    '''

    formulas = s[1:-1].split(",")
    for x in formulas: 
        if not formula(x): 
            return False
    return True

def implies_args(s): 
    '''(str) -> (str, str) 
    find the tuple of implication in s 
    '''

    depth = 0
    first = "" 
    second = "" 
    s = remove_bracket(s) 
    for i in range(len(s)): 
        ch = s[i] 
        if ch == "(": 
            depth += 1
        elif ch == ")": 
            depth -= 1
        elif ch == "," and depth == 0: 
            first = s[:i] 
            second = s[i + 1:] 
    return (first, second) 

def formula(F): 
    '''(str) -> bool 
    formula returns true if F is a valid formula
    '''

    F = F.strip()
    if F == "tru" or F == "fls": 
        return True
    if F.startswith("variable("): 
        return atom(remove_bracket(F)) 
    if F.startswith("neg("): 
        return formula(remove_bracket(F)) 
    if F.startswith("and(") or F.startswith("or("): 
        return formula_list(remove_bracket(F)) 
    if F.startswith("implies("): 
        first, second = implies_args(F) 
        return formula(first) and formula(second) 
    return False

def substitute(F, Asst): 
    '''(str, dict) -> str 
    substitute the variables in F with the assignments in Asst
    '''

    f = "" 
    tempf = F 
    while tempf != "": 
        if tempf.startswith("variable("): 
            var = remove_bracket(tempf[:tempf.find(")") + 1]) 
            if var in Asst: 
                f += Asst[var] 
                tempf = tempf[10 + len(var):] 
            else: 
                f += tempf[0] 
                tempf = tempf[1:] 
        else: 
            f += tempf[0] 
            tempf = tempf[1:] 
    return f 

def sub(F, Asst, G): 
    '''(str, dict, str) -> bool 
    Return true iff G us a formula which is a result of substituting the 
    variables of F with corresponding key/value from the dict Asst 
    '''

    f = substitute(F, Asst) 
    if formula(f): 
        return f == G
    return False

def evaluate(F): 
    '''(str, dict) -> str (tru or fls) 
    return tru or fls depending on the evaluation of F
    '''

    F = F.strip() 
    if F == "tru" or F == "fls": 
        return F 
    if F.startswith("neg("): 
        result = evaluate(remove_bracket(F)) 
        return negate(result) 
    if F.startswith("and("): 
        formulas = remove_bracket(F)[1:-1].split(",")
        for f in formulas: 
            if evaluate(f) == "fls": 
                return "fls"
        return "tru"
    if F.startswith("or("): 
        formulas = remove_bracket(F)[1:-1].split(",") 
        for f in formulas: 
            if evaluate(f) == "tru": 
                return "tru"
        return "fls"
    if F.startswith("implies("): 
        first, second = implies_args(F) 
        first = evaluate(first) 
        second = evaluate(second) 
        if first == "fls" or second == "tru": 
            result = "tru"
        else: 
            result = "fls"
        return result 
    return "fls"

def eval(F, A, V): 
    '''(str, dict, str) -> bool 
    Given V either "tru" or "fls", return true iff the result of evaluating 
    the formula F (substituted with values in A), is equal to V 
    '''

    F = F.strip() 
    F = substitute(F, A) 
    result = evaluate(F) 
    return result == V 


def negate(v): 
    '''(str) -> str 
    return the negation of v
    '''

    negation = {"tru" : "fls", "fls" : "tru"}
    return negation[v]

def test():
    print("==========================Formula==========================")
    print("===========================================================")
    print("---------------------------True----------------------------")
    print('formula("neg(tru)") == %s' % formula("neg(tru)"))
    print('formula("neg(variable(x))") == %s' % formula("neg(variable(x))"))
    print('formula("implies(neg(fls), variable(y))")) == %s' %
            formula("implies(neg(fls), variable(y))"))
    print('formula("and([variable(x), tru, tru])") == %s' % 
            formula("and([variable(x), tru, tru])")) 
    print("---------------------------False---------------------------")
    print('formula("foo") == %s' % formula("foo")) 
    print('formula("variable(X)") == %s' % formula("variable(X)")) 

    print("\n============================Sub============================") 
    print("===========================================================")
    print("---------------------------True----------------------------")
    print('sub("variable(x)", {}, "variable(x)")) == %s' % 
            sub("variable(x)", {}, "variable(x)"))
    print('sub("variable(x)", {"x" : "fls"}, "fls") == %s' % 
            sub("variable(x)", {"x" : "fls"}, "fls"))
    print('sub("neg(neg(variable(x)))", {"x" : "tru"}, "neg(neg(tru))") == %s' % 
            sub("neg(neg(variable(x)))", {"x" : "tru"}, "neg(neg(tru))")) 
    print("---------------------------False---------------------------")
    print('sub("variable(x)", {"x" : "neg(x)"}, "neg(x)")) == %s' %
            sub("variable(x)", {"x" : "neg(x)"}, "neg(x)")) 

    print("\n==============================Eval=========================") 
    print("===========================================================")
    print("---------------------------True----------------------------")
    print('eval("implies(implies(tru, fls), fls)", {}, "tru")) == %s' % 
            eval("implies(implies(tru, fls), fls)", {}, "tru"))
    print('eval("neg(variable(x))", {"x":"tru"}, "fls") == %s' %
            eval("neg(variable(x))", {"x":"tru"}, "fls")) 
    print("---------------------------False---------------------------")
    print('eval("implies(implies(tru, fls), fls)", {}, "fls") == %s' %
            eval("implies(implies(tru, fls), fls)", {}, "fls")) 
    print('eval("and([tru, tru])", {}, "fls") == %s' %
            eval("and([tru, tru])", {}, "fls")) 

if __name__=="__main__":
    test()
