# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"
# DISABLE_AUTO_UPDATE="true"
export UPDATE_ZSH_DAYS=31
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git
	dotenv
 	macos
	vagrant
	docker
	systemd)

[[ -e $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh

# Hack to load the profile
[[ -e /etc/profile ]] && emulate sh -c 'source /etc/profile'
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

###
# PROMPT
###
local hostname="%{$fg_bold[black]%}%m"
local ret_status="%(?:%{$fg_bold[green]%}> :%{$fg_bold[red]%}> %s)"
local ret_status="%(?:%{$fg_bold[green]%}> :%{$fg_bold[red]%}> %s)"
PROMPT='${hostname} ${ret_status}%{$fg_bold[green]%}%p%{$fg[cyan]%}%c%{$fg_bold[blue]%} $(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

###
# ENV
###
export PATH=$PATH:$HOME/.local/bin/

export LANG=en_US.UTF-8
export HOSTNAME=$(hostname -s)
export EDITOR="vim"
export VISUAL=$EDITOR

#unsetopt beep
unsetopt LIST_BEEP
unsetopt HIST_BEEP

# Go settings
export GOPATH=$HOME/.go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

###
# ALIAS/FUNCTION
###
alias gitvz='git config user.email "hugo.caron@verizon.com" && git config user.name "Hugo Caron"'
alias githca='git config user.email "hca443@gmail.com" && git config user.name "Hugo Caron"'

datetz () 
{ 
	echo "Vancouver: $(TZ='America/Vancouver' date)";
	echo "Montreal:  $(TZ='America/Montreal' date)";
	echo "London:    $(TZ='Europe/London' date)";
	echo "Paris:     $(TZ='Europe/Paris' date)";
	echo "Moscow:    $(TZ='Europe/Moscow' date)";
	echo "Hong Kong: $(TZ='Asia/Hong_Kong' date)";
	echo "Shanghai:  $(TZ='Asia/Shanghai' date)";
	echo "Seoul:     $(TZ='Asia/Seoul' date)";
	echo "Melbourne: $(TZ='Australia/Melbourne' date)"
}

# Windows machine
if [ -e /proc/sys/fs/binfmt_misc/WSLInterop ]; then
	eval `keychain -q --eval --agents ssh id_rsa`

	# wget -O ~/.dircolors https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark  
	if [ -f ~/.dir_colors ]; then  
		eval `dircolors ~/.dircolors`
	fi

	if type "nvim.exe" > /dev/null; then	
		nvim ()
		{
			nvim.exe --server \\\\.\\pipe\\nvim --remote $(wslpath -w $@)
		}
	fi
fi


# Macbook Air 
if [[ `uname` == "Darwin" ]]; then
	export HOMEBREW_NO_ANALYTICS=1
	export HOMEBREW_NO_AUTO_UPDATE=1
fi
