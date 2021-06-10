# python启动时，命令行选项放置在sys.argv中。
# 第一个元素是程序的名称，后续项是在命令行程序名称之后添加的选项
import sys
if len(sys.argv) != 3:
	sys.stderr.write("Usage: python %s inputfile outputfile\n" % sys.argv[0])
	raise SystemExit(1)
inputfile = sys.argv[1]
outputfile = sys.argv[2]

# 更复杂的命令行选项 optparse
import optparse
p = optparse.OptionParser()