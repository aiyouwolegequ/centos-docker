#!/bin/bash

yum install zsh -q -y
git clone -q --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh
cp /root/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
cd /root/.oh-my-zsh/themes
git clone -q https://github.com/dracula/zsh.git
mv zsh/dracula.zsh-theme .
rm -rf zsh
cd /root/.oh-my-zsh/plugins
git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone -q https://github.com/zsh-users/zsh-autosuggestions.git
git clone -q https://github.com/zsh-users/zsh-history-substring-search.git

cat > /root/.zshrc <<-EOF
export ZSH=/root/.oh-my-zsh
ZSH_THEME="dracula"
plugins=(sudo zsh-syntax-highlighting git autojump web-search zsh_reload colored-man-pages zsh-autosuggestions zsh-history-substring-search)
source $ZSH/oh-my-zsh.sh
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
alias vizsh="vim ~/.zshrc"
alias sourcezsh="source ~/.zshrc"
alias cat="pygmentize -g"
alias py="python"
alias pip="python -m pip"
alias py3="python3"
alias pip3="python3 -m pip"
EOF

chsh -s /bin/zsh root
env zsh