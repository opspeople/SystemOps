# python2
print "The values are", x, y, z
print x,y

# python3
print "The values are %d %7.5f %s" % (x, y, z)
print "The values are {0:d} {1:7.5f} {2}".format(x,y,z)

# 文件操作
f = open("outpur", "w")
print >> f,"hello world"
...
f.close()

