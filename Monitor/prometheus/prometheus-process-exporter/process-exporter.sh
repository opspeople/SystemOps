#!/bin/bash
process-exporter服务配置文件
all.yaml
# 配置文件可用的模板变量
{{.Comm}} 包含原始可执行文件的basename,/proc/stat中的2nd字段
{{.ExeBase}}包含可执行文件的basename 
{{.ExeFull}}包含可执行文件的完全限定路径
{{.Matches}}映射包含应用命令行tlb所产生的所有匹配项


# 匹配进程名
process-names:
  - name: "{{.Matches}}"
    cmdline:
      - 'rtpproxy'
  - name: "{{.Matches}}"
      - 'opensips'


# 匹配可执行文件的basename
process-names:
  - name: "{{.ExecBase}}"
    cmdline:
      - 'opensips'

# 匹配可执行文件的完全限定路径
process-names:
  - name: "{{.ExecFull}}"
    cmdline:
      - '/usr/local/sbin/opensips'

# 所有进程
process-names:
  - name: "{{.Comm}}"
    cmdline:
      - '.+'
