#!/bin/bash
通常我们需要让警报系统知道我们已经停止服务以进行维护，并且不希望触发警报。
或者，当上游出现问题时，我们需要将下游服务和应用程序“静音”。
Prometheus称这种警报静音为silence。
silence可以设定为特定时期，例如一小时，或者是一个时间窗口（如直到今天午夜）。
这是silence的到期时间或到期日期。
如果需要，我们也可以提前手动让silence过期（如果我们的维护比计划提前完成）。

001.通过Alertmanager控制slience

002.通过amtoo控制silence
# 使用amtool命令行
amtool --alertmanager.url=http://localhost:9093 silence \ 
add alertname=InstancesGone service=application1

查询silence
amtool --alertmanage.url=http://localhost:9093 silence query

使silence过期
amtool --alertmanage.url=http://localhost:9093 silence expire

