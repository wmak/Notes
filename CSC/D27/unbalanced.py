import gmpy
def unbalanced(N):
    a = gmpy.floor(gmpy.sqrt(N))
    i = 1
    while a - (2 * i) > 0:
        i += 1
        if N % (a - (2 * i)) == 0:
            print("DONE!! %d" % (a - (2 *i)))
            return i
        if i % 10000000 == 0:
            print("current %d" % i)
