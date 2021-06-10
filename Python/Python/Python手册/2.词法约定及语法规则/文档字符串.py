def fact(n):
	"This function computes a factorial"
	if (n <= 1)
		return 1
	else
		return n*fact(n-1)

print fact.__doc__
This function computes a factorial