# 1.sys模块
# sys模块代表了Python解释器，主要用于获取和Python解释器相关的信息
# sys模块常用属性和函数
import sys
sys.argv 		# 获取运行Python程序的命令行参数。其中sys.argv[0]通常就是指该Python程序
sys.byteorder	# 显示本地字节序的指示符。如果本地字节序是大端模式，则该属性返回big；否则返回little
sys.copyright	# 返回与Python解释器有关的版权信息
sys.executable	# 返回Python解释器在磁盘上的存储路径
sys.exit()		# 通过引发SystemExit异常来推出程序。将其放在Try块中不能阻止finally块的执行
sys.flags		# 该制度属性返回运行Python命令时指定的旗标
sys.getfilesystemencoding() # 返回当前系统中保存文件所有的字符集
sys.getrefcount(object)		# 返回指定对象的引用计数，当object对象的引用计数为0时，系统会回收该对象
sys.getrecursionlimit()		# 返回Python解释器当前支持的递归深度
sys.getswitchinterval()		# 返回当前Python解释器中线程切换的时间间隔
sys.implementation()		# 返回当前Python解释器的实现
sys.maxsize					# 返回Python整数支持的最大值
sys.modules		# 返回模块名和载入模块对应关系的字典
sys.path		# 指定Python查找模块的路径列表
sys.platform	# 返回Python解释器所在平台的标识符
sys.stdin		# 返回系统标准输入流----一个类文件对象
sys.stdout		# 返回系统标准输出流----一个类文件对象
sys.stderr		# 返回系统错误输出流----一个类文件对象
sys.version		# 返回当前Python解释器的版本信息

# 2.os模块
# os模块代表了程序所在的操作系统，主要用于获取程序运行所在操作系统的相关信息
os.name			# 返回导入依赖模块的操作系统名称
os.environ		# 返回当前系统上所有环境变量组成的字典
os.fsencode		# 该函数对类路径的文件名进行编码
os.fsdecode		# 该函数对类路径的文件名进行解码
os.PathLike		# 这是一个类，代表一个类路径对象
os.getenv 		# 获取指定环境变量
os.getlogin()	# 获取当前系统的登录用户名
os.getgit()		#
os.getpid()		# 获取当前进程ID
os.getppid()	# 获取当前进程的父进程ID
os.putenv(key, value)	# 该函数用于设置环境变量
os.cpu_count()		# 返回当前系统CPU数量
os.sep			# 返回路径分隔符
os.pathsep		# 返回当前系统上多条路径之间的分隔符
os.linesep		# 返回当前系统的换行符
os.urandom(size)	# 返回适合作为加密使用的、最多由N个字节组成的bytes对象

# 3.random模块
# random模块主要包含生成伪随机数的各种功能变量和函数
random.seed(a=None, version=2)	# 指定种子类初始化伪随机数生成器
random.randrange(start, stop[, step]) # 返回从start开始到stop结束，步长位step的随机数
random.randint(a, b)		# 生成一个范围为 a<=N<=b的随机数
random.choice(seq)		# 从seq中随机抽取一个元素，如果seq为空，则引发IndexError异常
random.choice(seq, weights=None, *, cum_weights=None, k=1)
random.shuffle(x[, random]) # 对序列x执行洗牌“随机排列操作”
random.sample(population, k) # 
random.random()		# 生成一个从0.0到1.0之间的伪随机浮点数
random.uniform(a,b)	# 生成一个范围为a<=N<=b的随机数

# 4.time
# time模块主要包含各种提供日期、时间功能的类和函数。
# 该模块既提供了把日期、时间格式转化为字符串的功能，也提供了从字符串恢复日期、时间的功能
