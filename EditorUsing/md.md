# Markdown 语法1 标题语法
#######################################
要创建标题，请在单词或短语前面添加井号 (#) , # 的数量代表了标题的级别
例如：
# 一级标题
## 二级标题
### 三级标题
#### 四级标题
##### 五级标题
###### 六级标题
使用 == 或 -- 标识一级标题和二级标题
一级标题
=======

二级标题
-------



# Markdown 语法2 段落语法
#######################################
要创建段落，请使用空白行将一行或多行文本进行分隔

I really like using Markdown.

I think I'll use it to format all of my documents from now on.

不要用空格（spaces）或制表符（ tabs）缩进段落。



# Markdown 语法3 换行语法
#######################################
在一行的末尾添加两个或多个空格，然后按回车键,即可创建一个换行。  



# Markdown 语法4 强调语法
#######################################
粗体
要加粗文本，请在单词或短语的前后各添加两个星号（asterisks）或下划线（underscores）。
**粗体** __粗体__
斜体
要用斜体显示文本，请在单词或短语前后添加一个星号（asterisk）或下划线（underscore）。
*斜体* _斜体_
斜体和粗体
要同时用粗体和斜体突出显示文本，请在单词或短语的前后各添加三个星号或下划线
***粗体加斜体*** ___粗体加斜体___



# Markdown 语法5 引用语法
#######################################
## 要创建块引用，请在段落前添加一个 > 符号。
> Dorothy followed her through many of the beautiful rooms in her castle.
## 多个段落的块引用
块引用可以包含多个段落。为段落之间的空白行添加一个 > 符号
> Dorothy followed her through many of the beautiful rooms in her castle.
>
> The Witch bade her clean the pots and kettles and sweep the floor and keep the fire fed with wood.
## 嵌套块引用
块引用可以嵌套。在要嵌套的段落前添加一个 >> 符号。
> Dorothy followed her through many of the beautiful rooms in her castle.
>
>> The Witch bade her clean the pots and kettles and sweep the floor and keep the fire fed with wood.
## 带有其它元素的块引用
> #### The quarterly results look great!
>
> - Revenue was off the chart.
> - Profits were higher than ever.
>
>  *Everything* is going according to **plan**.



# Markdown 语法6 列表语法
##########################################
## 有序列表
要创建有序列表，请在每个列表项前添加数字并紧跟一个英文句点。
数字不必按数学顺序排列，但是列表应当以数字 1 起始。
1. First item
2. Second item
3. Third item
4. Fourth item

## 无序列表
要创建无序列表，请在每个列表项前面添加破折号(-)、星号(*)或加号(+)。
缩进一个或多个列表项可创建嵌套列表。
+ First item
+ Second item
+ Third item
+ Fourth item

## 在列表中嵌套其他元素
### 段落
要在保留列表连续性的同时在列表中添加另一种元素，请将该元素缩进四个空格或一个制表符，如下例所示：
*   This is the first list item.
*   Here's the second list item.

    I need to add another paragraph below the second list item.

*   And here's the third list item.

### 引用块
*   This is the first list item.
*   Here's the second list item.

    > A blockquote would look great below the second list item.

*   And here's the third list item.

### 代码块
代码块通常采用四个空格或一个制表符缩进。
当它们被放在列表中时，请将它们缩进八个空格或两个制表符。
1.  Open the file.
2.  Find the following code block on line 21:

        <html>
          <head>
            <title>Test</title>
          </head>

3.  Update the title to match the name of your website.

### 图片
1.  Open the file containing the Linux mascot.
2.  Marvel at its beauty.

    ![Tux, the Linux mascot](/assets/images/tux.png)

3.  Close the file.

### 列表
1. First item
2. Second item
3. Third item
    - Indented item
    - Indented item
4. Fourth item



# Markdown 语法7 代码语法
######################################################
要将单词或短语表示为代码，请将其包裹在反引号 (`) 中
## 转义反引号`
如果你要表示为代码的单词或短语中包含一个或多个反引号，则可以通过将单词或短语包裹在双反引号(``)中。``


# Markdown 语法8 分割线语法
######################################################
要创建分隔线，请在单独一行上使用三个或多个星号 (***)、破折号 (---) 或下划线 (___) ，并且不能包含其他内容


# Markdown 语法9 链接语法
#######################################################
链接文本放在中括号内，链接地址放在后面的括号中，链接title可选。
Go to [baidu](https://www.baidu.com/)
## 给链接增加 Title
链接title是当鼠标悬停在链接上时会出现的文字，这个title是可选的，它放在圆括号中链接地址后面，跟链接地址之间以空格分隔。
Go to [baidu](https://www.baidu.com/ "点击前往百度")
## 网址和Email地址
使用尖括号可以很方便地把URL或者email地址变成可点击的链接。
## 带格式化的链接
强调 链接, 在链接语法前后增加星号。 要将链接表示为代码，请在方括号中添加反引号。
I love supporting the **[EFF](https://eff.org)**.
This is the *[Markdown Guide](https://www.markdownguide.org)*.
See the section on [`code`](#code).
## 引用类型链接
## 链接的第一部分格式
## 链接的第二部分格式
引用类型链接的第二部分使用以下属性设置格式：
	放在括号中的标签，其后紧跟一个冒号和至少一个空格（例如[label]:）。
	链接的URL，可以选择将其括在尖括号中。
	链接的可选标题，可以将其括在双引号，单引号或括号中。


# Markdown 语法10 图片语法
##############################################################
插入图片Markdown语法代码：![图片alt](图片链接 "图片title")。
对应的HTML代码：<img src="图片链接" alt="图片alt" title="图片title">
## 链接图片
给图片增加链接，请将图像的Markdown 括在方括号中，然后将链接添加在圆括号中。
[![沙漠中的岩石图片](/assets/img/shiprock.jpg "Shiprock")](https://markdown.com.cn)


# Markdown 语法11 转义字符语法
要显示原本用于格式化 Markdown 文档的字符，请在字符前面添加反斜杠字符 () 。
\* Without the backslash, this would be a bullet in an unordered list.
## 可做转义的字符
\\
\`
\*
\_
\{}
\[]
\()
\#
\+
\-
\.
\!
\|
## 特殊字符自动转义
在 HTML 文件中，有两个字符需要特殊处理： < 和 & 。
< 符号用于起始标签，&符号则用于标记HTML实体，
如果你只是想要使用这些符号，你必须要使用实体的形式，像是 &lt; 和 &amp;。

& 符号其实很容易让写作网页文件的人感到困扰，如果你要打「AT&T」 ，你必须要写成「AT&amp;T」 ，还得转换网址内的 & 符号，如果你要链接到：
http://images.google.com/images?num=30&q=larry+bird

你必须要把网址转成：
http://images.google.com/images?num=30&amp;q=larry+bird

才能放到链接标签的 href 属性里。不用说也知道这很容易忘记，这也可能是 HTML 标准检查所检查到的错误中，数量最多的。

Markdown 允许你直接使用这些符号，它帮你自动转义字符。如果你使用 & 符号的作为 HTML 实体的一部分，那么它不会被转换，而在其它情况下，它则会被转换成 &amp;。所以你如果要在文件中插入一个著作权的符号，你可以这样写：
&copy;

Markdown 将不会对这段文字做修改，但是如果你这样写：

AT&T
Markdown 就会将它转为：

AT&amp;T
类似的状况也会发生在 < 符号上，因为 Markdown 支持 行内 HTML ，如果你使用 < 符号作为 HTML 标签的分隔符，那 Markdown 也不会对它做任何转换，但是如果你是写：

4 < 5
Markdown 将会把它转换为：

4 &lt; 5
需要特别注意的是，在 Markdown 的块级元素和内联元素中， < 和 & 两个符号都会被自动转换成 HTML 实体，这项特性让你可以很容易地用 Markdown 写 HTML。（在 HTML 语法中，你要手动把所有的 < 和 & 都转换为 HTML 实体。）

