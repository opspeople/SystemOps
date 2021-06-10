#!/bin/bash
# kubectl命令自动补全配置.sh
yum install -y bash-completion
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)
