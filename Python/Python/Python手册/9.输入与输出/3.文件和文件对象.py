# 内置函数open(name [,mode [, bufsize]])用于发开和创建文件对象
f = open("foo")
f = open("foo", 'r')
f = open("foo", "w")

# 文件方法
f.read([n])
f.readline([n])
f.readliens([size])
f.write(s)
f.writelines(lines)
f.close()
f.tell()
f.seek(offset [, whence])
f.isatty()
f.flush()
f.truncate([size])
f.fileno()
f.next()

# 文件对象属性
f.closed
f.mode
f.name
f.softspace
f.newline
f.encoding
