# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source list of alias commands
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# Auto-load a set of modules
if [ -f ~/.init_modules ]; then
	. ~/.init_modules
fi
