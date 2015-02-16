'''Given a value x and a list of tests of test pairs, return a list of names of
all the tests from the list that x passes'''
def pypass(x, tests):
    def pypass_inner(tests):
        if len(tests) == 1:
            if tests[0].test(x):
                return tests[0].string
        elif tests[0].test(x):
            return tests[0].string + pypass_inner(tests[1:])
        else:
            return pypass_inner(tests[1:])
    return pypass_inner(tests)

class Test(object):
    def __init__(self, test, string):
        self.test = test
        self.string = string
