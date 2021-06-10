
yum -y install git

git clone https://github.com/pyenv/pyenv.git ~/.pyenv

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile

# 查看当前使用的python版本
pyenv version 
system (set by /root/.pyenv/version)  # system表示系统安装的版本

# 查看可安装的版本列表
pyenv install --list
Available versions:
  2.1.3
  2.2.3
  2.3.7
  2.4
  ...

# 安装其他版本
pyenv install 3.6.2

# 查看已安装的版本
pyenv versions
* system (set by /root/.pyenv/version)
  3.6.2

# 将3.6.2作为当前使用版本
pyenv global 3.6.2 # 全局设置版本
# pyenv local 3.6.2 # 局部设置版本，当前目录生效
pyenv versions    
  system
* 3.6.2 (set by /root/.pyenv/version)

# 查看所有pyenv的指令
pyenv commands
