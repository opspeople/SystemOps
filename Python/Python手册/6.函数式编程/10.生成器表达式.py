(expression for item1 in iterable1 if condition1)

>>> a = [1, 2, 3, 4]
>>> b = (10*i for i in a)
>>> b.__next__()
10
>>> b.__next__()
20
>>> b.__next__()
30