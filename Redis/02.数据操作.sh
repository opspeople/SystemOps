#!/bin/bash
每个数据操作前一定要明白每个操作都是代价，以时间复杂度和对应查询集或者结果集大小为衡量

key操作
	keys *user* # 
	keys *
	支持的通配符
	    * 任意多个字符
	    ? 单个字符
	    [] 统配括号内的某1个字符
	注意： 生产禁止，更安全的做法是scan


