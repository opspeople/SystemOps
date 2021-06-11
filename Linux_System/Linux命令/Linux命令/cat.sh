#!/usr/bin/env bash
-A,--show-all 			等价于 -vET
-v,--show-nonprinting 	除了 LFD 和 TAB 之外所有控制符用 ^ 和 M- 记方式显示。
-e     					等价于 -vE
-T, --show-tabs			把 TAB 字符显示为 ^I
-E,--show-ends			在每行结束显示 $
-b,--number-nonblank	给非空输出行编号
-n,--number 			给所有输出行编号
-s,--squeeze-blank		将所有的连续的多个空行替换为一个空行
-t 						等价于 -vT

# cat 向文件中添加内容
# 1.覆盖
cat > test.txt << EOF
> hello world!
> EOF

# 2.追加
cat >> test.txt << EOF
> hello world!
> EOF
