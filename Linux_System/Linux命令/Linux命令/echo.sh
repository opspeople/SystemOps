简单输出
echo "Hello world!"
echo 'Hello world!'
# echo 默认在输出结果添加换行符\n

printf
printf "Hello world! \n"

printf "%-5s %-10s %-4s\n" No Name Mark
No    Name       Mark
printf "%-5s %-10s %-4.2f\n" 1 Sarath 80.123
1     Sarath     80.12


echo 中转义换行符
echo -n "Hello world!" # -n 禁止echo在尾部添加换行符
echo -e "1\t2\t3"		# -e 接受双包含转义序列的双引号字符串作为参数
1	2	3	

echo 打印彩色输出
# 使用转义序列在终端生成彩色文本
文本颜色是由对应的色彩码来描述的，包括：
	重置 0
	黑色 30
	红色 31
	绿色 32
	黄色 33
	蓝色 34
	洋红 35
	青色 36
	白色 37

echo -e "\e[1;31m This is a test \e[0m"
\e[1;31m 	一个转义字符串，将颜色设置为红色
\e[0m 		将颜色重新置回

设置背景颜色，使用的颜色码，包括：
	重置 0
	黑色 40
	红色 41
	绿色 42
	黄色 43
	蓝色 44
	洋红 45
	青色 46
	白色 47

echo -e "\e[1;31m This is a test \e[0m"

同时设置字体颜色和背景颜色
echo -e "\e[31;41m This is a test \e[0;0m"

