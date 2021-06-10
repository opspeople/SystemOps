#!/usr/local/bin/python3

from collections import OrderdDict

d = OrderdDict()
d['foo'] = 1
d['bar'] = 2
d['spam'] = 3

for key in d:
	print(key, d[key])
