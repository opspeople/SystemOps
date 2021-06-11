def countdown(n):
	print("Counting down from %d" % n)
	while n>0:
		yield n
		n -= 1
	return n

