移动光标
	# hjkl
	# 2w 向前移动两个单词
	# 3e 向前移动到第 3 个单词的末尾
	# 0 移动到行首
	# $ 当前行的末尾
	# gg 文件第一行
	# G 文件最后一行
	# 行号+G 指定行
	# <ctrl>+o 跳转回之前的位置
	# <ctrl>+i 返回跳转之前的位置

退出
	# <esc> 进入正常模式
	# :q! 不保存退出
	# :wq 保存后退出

删除
	# x 删除当前字符
	# dw 删除至当前单词末尾
	# de 删除至当前单词末尾，包括当前字符
	# d$ 删除至当前行尾
	# dd 删除整行
	# 2dd 删除两行

修改
	# i 插入文本
	# A 当前行末尾添加
	# r 替换当前字符
	# o 打开新的一行并进入插入模式

撤销
	# u 撤销
	# <ctrl>+r 取消撤销

复制粘贴剪切
	# v 进入可视模式
	# y 复制
	# p 粘贴
	# yy 复制当前行
	# dd 剪切当前行

状态
	#<ctrl>+g 显示当前行以及文件信息

查找
	# / 正向查找（n：继续查找，N：相反方向继续查找）
	# ？ 逆向查找
	# % 查找配对的 {，[，(
	# :set ic 忽略大小写
	# :set noic 取消忽略大小写
	# :set hls 匹配项高亮显示
	# :set is 显示部分匹配

替换
	# :s/old/new 替换该行第一个匹配串
	# :s/old/new/g 替换全行的匹配串
	# :%s/old/new/g 替换整个文件的匹配串

折叠
	# zc 折叠
	# zC 折叠所有嵌套
	# zo 展开折叠
	# zO 展开所有折叠嵌套

执行外部命令
	# :!shell 执行外部命令

.vimrc
	cd Home               // 进入 Home 目录
	touch .vimrc          // 配置文件

	# Unix
	# vim-plug
	# Vim
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	# Neovim
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


