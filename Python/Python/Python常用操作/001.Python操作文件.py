#!/usr/bin/python3
一、文件的打开和关闭
open() 函数
f1 = open(r'd:\测试文件.txt', mode='r', encoding='utf-8')
content = f1.read()
print(content)
f1.close()

with open(r'd:\测试文件.txt', mode='r', encoding='utf-8') as f1:
    content = f1.read()
    print(content)

1.open()内置函数，open底层调用的是操作系统的接口。
2.f1变量，又叫文件句柄，通常文件句柄命名有f1，fh，file_handler，f_h，对文件进行的任何操作，都得通过文件句柄.方法的形式。
3.encoding:可以不写。不写参数，默认的编码本是操作系统默认的编码本。windows默认gbk，linux默认utf-8，mac默认utf-8。
4.mode:可以不写。默认mode='r'。
5.f1.close()关闭文件句柄。
6.另外使用with open()的好处：
#优点1：不用手动关闭文件句柄。
with open('文件操作的读', encoding='utf-8') as f1:
    print(f1.read())
    
#优点2：一个语句可以操作多个文件句柄。
with open('文件操作的读', encoding='utf-8') as f1, \
        open('文件操作的写', encoding='utf-8', mode='w') as f2:
    print(f1.read())
    f2.write('hahaha')

7.路径书写的三种方法
(1):\\
file = open('C:\\Users\\Python基础\\xxx.txt')

(2): r'\'
file = open(r'C:\Users\Python基础\xxx.txt')

(3):'/'(推荐)
file = open('C:/Users/Python基础/xxx.txt')

常用文件的访问模式
# 打开文件的模式（默认为文本模式）
r 只读模式【默认模式，文件必须存在，不存在则抛出异常】
w 只写模式【不可读；不存在则创建；存在则清空内容在写入】
a 只追加写模式【不可读；不存在则创建；存在则只追加内容】

# 对于非文本文件，我们只能使用b模式。注：以b方式打开时，读取到的内容是字节类型，写入时也需要提供字节类型，不能指定编码。
rb 以二进制读取
wb 以二进制写入
ab 以二进制追加

# ‘+’模式（就是增加了一个功能）
r+b 读写【可读，可写】
w+b 写读【可写，可读】
a+b 写读【可写，可读】 

# 关于r+模式：打开一个文件用于读写，文件指针默认将会放在文件的开头。注意：如果在读写模式下，先写后读，那么文件就会出问题，因为默认光标是在文件的最开始，你要是先写，则写入的内容会将原内容覆盖掉，直到覆盖到你写完的内容，然后在从后面开始读取。
1. 先读后写
f1 = open('其他模式', encoding='utf-8', mode='r+')
content = f1.read()
print(content)
f1.write('Python开发者')
f1.close()

2. 先写后读（错误实例）
f1 = open('其他模式', encoding='utf-8', mode='r+')
f1.write('Python开发者')
content = f1.read()
print(content)  # 最帅
f1.close()

二、文件的读取和写入
1.读取
# read()全部读取出来:用rb模式打开，不用写encoding
f1 = open('文件操作的读', encoding='utf-8')
content = f1.read()
print(content, type(content))
f1.close()

f1 = open(r'C:\Users\lenovo\Desktop\编码进阶.png', mode='rb')
content = f1.read()
print(content)
f1.close()

# read(n) 按照字符读取（r模式），按照字节读取（rb模式）
f1 = open('文件操作的读', encoding='utf-8')
content = f1.read(6)
print(content)  # lucy最帅
f1.close()

# readline() 读取一行
f1 = open('文件操作的读', encoding='utf-8')
print(f1.readline().strip())  # lucy最帅
print(f1.readline())  # lucy很励志\n
f1.close()

# readlines() 返回一个列表，列表中的每个元素是原文件的每一行。如果文件很大，占内存，容易崩盘。
f1 = open('文件操作的读', encoding='utf-8')
li = f1.readlines()
print(li)  # ['lucy最帅\n', 'lucy很励志\n', 'abcdef\n', '哈哈哈']
f1.close()

# for 循环读取。文件句柄是一个迭代器。特点是每次循环只在内存中占一行的数据，非常节省内存。
f1 = open('文件操作的读', encoding='utf-8')
for line in f1:
    print(line.strip())
f1.close()

2.写入
# w模式
没有文件，则创建文件，写入内容；如果文件存在，先清空原文件内容，在写入新内容。
f1 = open('文件操作的写', encoding='utf-8', mode='w')
f1.write('lucy真帅')
f1.close()

# wb模式
f1 = open(r'C:\Users\lenovo\Desktop\编码进阶.png', mode='rb')
content = f1.read()
f1.close()

f2 = open('图片.jpg', mode='wb')
f2.write(content)
f2.close()

# 关于清空
关闭文件句柄，再次以w模式打开此文件时，才会清空。

3.指针定位
# tell() 方法用来显示当前指针的位置
f = open('test.txt')
print(f.read(10))  # read 指定读取的字节数
print(f.tell())    # tell()方法显示当前文件指针所在的文字
f.close()

# seek(offset,whence)方法用来重新设定指针的位置。
offset:表示偏移量
whence:只能传入012中的一个数字。 
0 表示从文件头开始
1 表示从当前位置开始
2 表示从文件的末尾开始

f = open('test.txt','rb')  # 需要指定打开模式为rb,只读二进制模式
print(f.read(3))
print(f.tell())
f.seek(2,0)   # 从文件的开头开始，跳过两个字节
print(f.read())
f.seek(1,1) # 从当前位置开始，跳过一个字节
print(f.read())
f.seek(-4,2) # 从文件末尾开始，往前跳过四个字节
print(f.read())
f.close()

三、实现文件拷贝功能
import os

file_name = input('请输入一个文件路径:')
if os.path.isfile(file_name):
    old_file = open(file_name, 'rb')  # 以二进制的形式读取文件

    names = os.path.splitext(file_name)
    new_file_name = names[0] + '.bak' + names[1]

    new_file = open(new_file_name, 'wb')  # 以二进制的形式写入文件

    while True:
        content = old_file.read(1024)  # 读取出来的内容是二进制
        new_file.write(content)
        if not content:
            break

    new_file.close()
    old_file.close()
else:
    print('您输入的文件不存在')

四、CSV文件的读写
CSV文件
# CSV文件：Comma-Separated Values，中文叫逗号分隔值或者字符分割值，其文件**以纯文本的形式存储表格数据。
# **可以把它理解为一个表格，只不过这个表格是以纯文本的形式显示的，单元格与单元格之间，默认使用逗号进行分隔；每行数据之间，使用换行进行分隔。
# Python中的csv模块，提供了相应的函数，可以让我们很方便的读写csv文件
CSV文件的写入
import csv

# 以写入方式打开一个csv文件
file = open('test.csv','w')

# 调用writer方法，传入csv文件对象，得到的结果是一个CSVWriter对象
writer = csv.writer(file)

# 调用CSVWriter对象的writerow方法，一行行的写入数据
writer.writerow(['name', 'age', 'score'])

# 还可以调用writerows方法，一次性写入多行数据
writer.writerows([['zhangsan', '18', '98'],['lisi', '20', '99'], ['wangwu', '17', '90'], ['jerry', '19', '95']])
file.close()

CSV文件的读取
import csv

# 以读取方式打开一个csv文件
file = open('test.csv', 'r')

# 调用csv模块的reader方法，得到的结果是一个可迭代对象
reader = csv.reader(file)

# 对结果进行遍历，获取到结果里的每一行数据
for row in reader:
    print(row)

file.close()

五、将数据写入内存
StringIO
# StringIO可以将字符串写入到内存中，像操作文件一下操作字符串。
from io import StringIO

# 创建一个StringIO对象
f = StringIO()
# 可以像操作文件一下，将字符串写入到内存中
f.write('hello\r\n')
f.write('good')

# 使用文件的 readline和readlines方法，无法读取到数据
# print(f.readline())
# print(f.readlines())

# 需要调用getvalue()方法才能获取到写入到内存中的数据
print(f.getvalue())

f.close()

BytesIO
# 如果想要以二进制的形式写入数据，可以使用BytesIO类，它的用法和StringIO相似，只不过在调用write方法写入时，需要传入二进制数据。
from io import BytesIO

f = BytesIO()
f.write('你好\r\n'.encode('utf-8'))
f.write('中国'.encode('utf-8'))

print(f.getvalue())
f.close()

六、sys模块的使用
# sys.stdin 接收用户的输入，就是读取键盘里输入的数据，默认是控制台。
#input方法就是读取 sys.stdin 里的数据。
import sys
s_in = sys.stdin
while True:
    content = s_in.readline().rstrip('\n')
    if content == '':
        break
    print(content)

sys.stdout 标准输出，默认是控制台
import sys
m = open('stdout.txt', 'w', encoding='utf8')
sys.stdout = m
print('hello')
print('yes')
print('good')
m.close()
# 运行结果：生成一个stdout.txt文件，文件内容如下：
hello
yes
good
# sys.stderr 错误输出，默认是控制台
import sys
x = open('stderr.txt', 'w', encoding='utf8')
sys.stderr = x
print(1 / 0)
x.close()

七、序列化和反序列化
# 通过文件操作，我们可以将字符串写入到一个本地文件。但是，如果是一个对象(例如列表、字典、元组等)，就无法直接写入到一个文件里，需要对这个对象进行序列化，然后才能写入到文件里。
# 序列化：将数据从内存持久化保存到硬盘的过程。
# 反序列化：将数据从硬盘加载到内存的过程。
# python 里存入数据只支持存入字符串和二进制。
# json:将Python里的数据(str/list/tuple/dict)等转换成为对应的json。
# pickle:将Python里任意的对象转换成为二进制。
# Python中提供了JSON和pickle两个模块用来实现数据的序列化和反序列化。
JSON模块
# JSON(JavaScriptObjectNotation, JS对象简谱)是一种轻量级的数据交换格式，它基于 ECMAScript 的一个子集，采用完全独立于编程语言的文本格式来存储和表示数据。
# JSON的本质是字符串，区别在于json里要是用双引号表示字符串。
使用JSON实现序列化
1.dumps方法的作用是把对象转换成为字符串，它本身不具备将数据写入到文件的功能。
import json
file = open('names.txt', 'w')
names = ['zhangsan', 'lisi', 'wangwu', 'jerry', 'henry', 'merry', 'chris']
# file.write(names)  出错，不能直接将列表写入到文件里

# 可以调用 json的dumps方法，传入一个对象参数
result = json.dumps(names)

# dumps 方法得到的结果是一个字符串
print(type(result))  # <class 'str'>

# 可以将字符串写入到文件里
file.write(result)

file.close()

2.dump方法可以在将对象转换成为字符串的同时，指定一个文件对象，把转换后的字符串写入到这个文件里。
import json

file = open('names.txt', 'w')
names = ['zhangsan', 'lisi', 'wangwu', 'jerry', 'henry', 'merry', 'chris']

# dump方法可以接收一个文件参数，在将对象转换成为字符串的同时写入到文件里
json.dump(names, file)
file.close()

使用JSON实现反序列化
1.loads方法需要一个字符串参数，用来将一个字符串加载成为Python对象。
import json

# 调用loads方法，传入一个字符串，可以将这个字符串加载成为Python对象
result = json.loads('["zhangsan", "lisi", "wangwu", "jerry", "henry", "merry", "chris"]')
print(type(result))  # <class 'list'>

2.load方法可以传入一个文件对象，用来将一个文件对象里的数据加载成为Python对象。
import json

# 以可读方式打开一个文件
file = open('names.txt', 'r')

# 调用load方法，将文件里的内容加载成为一个Python对象
result = json.load(file)

print(result)
file.close()

pickle模块
# 和json模块类似，pickle模块也有dump和dumps方法可以对数据进行序列化，同时也有load和loads方法进行反序列化。
# 区别在于，json模块是将对象转换成为字符串，而pickle模块是将对象转换成为二进制。
# pickle模块里方法的使用和json里方法的使用大致相同，需要注意的是，pickle是将对象转换成为二进制
# 所以，如果想要把内容写入到文件里，这个文件必须要以二进制的形式打开。
使用pickle模块实现序列化
1.dumps方法将Python数据转换成为二进制
import pickle
names = ['张三', '李四', '杰克', '亨利']
b_names = pickle.dumps(names)
# print(b_names)
file = open('names.txt', 'wb')
file.write(b_names)  # 写入的是二进制，不是存文本
file.close()

2.dump方法将Python数据转换成为二进制，同时保存到指定文件
import pickle
names = ['张三', '李四', '杰克', '亨利']
file2 = open('names.txt', 'wb')
pickle.dump(names, file2)
file2.close()

使用pickle模块实现反序列号
1.loads方法，将二进制加载成为Python数据
import pickle
file1 = open('names.txt', 'rb')
x = file1.read()
y = pickle.loads(x)
print(y)
file1.close()

2.load方法，读取文件，并将文件的二进制内容加载成为Python数据
import pickle
file3 = open('names.txt', 'rb')
z = pickle.load(file3)
print(z)

JSON与pickle区别
json模块
1.将对象转换成为字符串，不管是在哪种操作系统，哪种编程语言里，字符串都是可识别的。
2.json就是用来在不同平台间传递数据的。
3.并不是所有的对象都可以直接转换成为一个字符串，下标列出了Python对象与json字符串的对应关系。
dict			object 
list,tuple		array
str 			string 
int,float		number
True 			true 
False			false 
None 			null
4.如果是一个自定义对象，默认无法装换成为json字符串，需要手动指定JSONEncoder
如果是将一个json串重新转换成为对象，这个对象里的方法就无法使用了
import json
class MyEncode(json.JSONEncoder):
    def default(self, o):
        # return {"name":o.name,"age":o.age}
        return o.__dict__

class Person(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

      def eat(self):
          print(self.name+'正在吃东西')

p1 = Person('zhangsan', 18)

# 自定义对象想要转换成为json字符串，需要给这个自定义对象指定JSONEncoder
result = json.dumps(p1, cls=MyEncode)
print(result)  # {"name": "zhangsan", "age": 18}

# 调用loads方法将对象加载成为一个对象以后，得到的结果是一个字典
p = json.loads(result)
print(type(p))


pickle模块
pickle序列化是将对象按照一定的规则转换成为二进制保存，它不能跨平台传递数据。

pickle的序列化会将对象的所有数据都保存。