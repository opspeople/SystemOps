#!/usr/bin/bash
# 正则表达式官网
# http://www.regexlab.com/zh/regref.htm

# 定义
# 正则表达式 regular expression 就是用一个 字符串 来描述一个特征，然后去验证另一个字符是否符合这个特征。

# 用途
# （1）验证字符串是否符合指定特征
# （2）查找字符串
# （3）替换字符串

# 1.正则表达式规则
# 1.1 普通字符
	字母
	数字
	汉子
	下划线
	标点符号

# 1.2 简单的转义字符
	# 不便书写的字符
	\r 回车
	\n 换行
	\t 制表符
	\\ \ 本身
	# 特殊的标点符号
	\^	^符号本身
	\$	$符号本身
	\.	.符号本身

# 1.3 能够与多种字符匹配的表达式
	\d 任意一个数字，0~9中的任意一个
	\w 任意一个字母或下划线，A~Z,a~z,0~9,_
	\s 包括空格、制表符、换页符等空白字符的其中任意一个
	.	匹配除了换行符\n以外的任意一个字符

# 1.4 自定义能够匹配'多种字符'的表达式
	使用 [] 包含一系列字符，能够匹配其中任意一个字符
	使用 [^] 包含一系列字符，则能够匹配其中字符之外的任意一个字符
	[ab5@] 	匹配'a'或'b'或'5'或'@'
	[0-9] 	匹配0~9之间的任意一个数字
	[^2-5]	匹配2~5之外的任意一个数字

# 1.5 修饰匹配次数的特殊符号
	{n} 	表达式重复n次，如"a{5}"相当于"aaaaa"
	{m,n} 	表达式重复m到n次，如"ab{2,4}"相当于"abb"或"abbb"或"abbbb"
	{m,}	表达式至少重复m次
	{,n}	表达式最多出现n次
	?		表达式重复0次或1次
	+		表达式至少重复1次
	* 		表达式不出现或出现任意次

# 1.6 其他一些代表抽象意义的特殊符号
	$ 与字符串结束的地方匹配，不匹配任何字符
	\b 匹配一个单词的边界，也就是单词和空格之间的位置
	# 一些符号可以影响表达式内部的子表达式之间的关系
		| 	左右两边表达式之间"或"关系，匹配左边或者右边
		() 	（1）在被修饰匹配次数的时候，括号中的表达式可以作为整体被修饰
			（2）取匹配结果的时候，括号中的表达式匹配到的内容可以被单独得到

# 2.正则表达式中的一些高级规则
# 2.1 匹配次数中的贪婪与非贪婪
	贪婪匹配--尽可能多的匹配 针对字符串"dxxdxxd"
		(d)(\w+) # \w+将匹配第一个"d"之后的所有字符"xxdxxd"
		(d)(\w+)(d)	# "\w+"将匹配第一个"d"和最后一个"d"之间的所有字符"xxdxx"
	非贪婪模式--尽可能少的匹配 针对字符串
		(d)(\w+?) # 匹配字符串"x"
		(d)(\w+?)(d) # 匹配字符串"xx"
# 2.2 反向引用 \1,\2...
	表达式在匹配时，表达式引擎会将小括号"()"包含的表达式所匹配到的字符串记录下来。
	在获取匹配结果的时候，小括号包含的表达式所匹配到的字符串可以单独获取。
	表达式后边的部分，可以引用前面"括号内的子匹配已经匹配到的字符串"。引用方法是"\"加上一个数字
	\1 引用第1对括号内匹配到的字符串
	\2 引用第2对括号内匹配到的字符串
	"('|")(.*?)(\1)"在匹配"'Hello',"World""时，匹配结果是：成功；匹配到的内容是"'Hello'"。再次匹配下一个时，可以匹配到""World""
	"(\w)\1{4,}"

# 2.3 预搜索，不匹配；方向预搜索，不匹配
	正向预搜索
		(?=xxxxx)
		(?!xxxxx)
	反向预搜索
		(?<=xxxxx)
		(?<!xxxxx)

