检索单个列
	SELECT id FROM test_table;

检索多个列
	SELECT id,name FROM test_table;

检索所有列
	SELECT * FROM test_table;

检索不同的行，对检索结果去重
	SELECT DISTINCT * FROM test_table;

限制查询显示结果
	SELECT * FROM test_table limit 10;
	SELECT * FROM test_table limit 10,10;  # 显示从10行开始的后10行

查询是完全限定表名
	SELECT test_table.id,test_table.name FROM test_db.test_table limit 10;

查询结果处理
排序数据
	ORDER BY
	SELECT * FROM test_table ORDER BY id;
	按多列进行排序
	SELECT * FROM test_table ORDER BY id,name;
	指定排序顺序
	SELECT * FROM test_table ORDER BY id,name DESC; # 降序，默认是升序

	SELECT * FROM test_table ORDER by id limit 1;


过滤数据 where
	SELECT * FROM test_table where id='123456';
	where 子句操作符
	    = 等于
	    <> 不等于
	    != 不等于
	    < 小于
	    <= 小于等于
	    > 大于
	    >= 大于等于
	    BETWEEN 在指定范围之间
	空值检查
	SELECT * FROM test_table where id IS NULL;

	组合where子句
	    AND 操作符
	    SELECT * FROM test_table where id='123456' AND name='test_name';
	    OR 操作符
	    SELECT * FROM test_table where id='123456' OR name='test_name';
	    当 AND 和 OR 存在多个时，先计算 AND
	    IN 操作符
	    SELECT * FROM test_table where id IN ('123456','456789');
	    NOT 操作符
	    SELECT * FROM test_table where id NOT IN ('123456','456789');

