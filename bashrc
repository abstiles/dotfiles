if [ -z $BASHRC_LOADED ]; then
    export BASHRC_LOADED=1
    PATH=`readlink -f $HOME`/scripts:$PATH
    export PATH;
fi

# This is how gnome-terminal identifies itself.
if [[ ( "$COLORTERM" == "gnome-terminal" ) && ( $TERM == xterm* ) ]]; then
	# Set the TERM value to something with an appropriate termcap entry and
	# reload /etc/profile to ensure TERM-specific settings are correct
	TERM=gnome-256color
	source /etc/profile
fi

export PKG_CONFIG_PATH="/usr/lib/pkgconfig"
export TCLLIBPATH="~/tcl_packages"

export CVSEDITOR=/usr/bin/vim
export CVSROOT=:ext:astiles@kop-sds-repos.qlogic.org:/cvs
export CVS_RSH=/usr/bin/ssh

export BROWSER=/usr/bin/google-chrome
export MANPAGER=vless

function VIMRUNTIME() {
	echo -n `vim -e -T dumb --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' | tr -d '\015'`
}

source ~/.bash_aliases

source ~/.bash_prompt

#export PERL_LOCAL_LIB_ROOT="/qlogic/home/5125/astiles/perl5";
#export PERL_MB_OPT="--install_base /qlogic/home/5125/astiles/perl5";
#export PERL_MM_OPT="INSTALL_BASE=/qlogic/home/5125/astiles/perl5";
#export PERL5LIB="/qlogic/home/5125/astiles/perl5/lib/perl5/i386-linux-thread-multi:/qlogic/home/5125/astiles/perl5/lib/perl5:$PERL5LIB";
#export PATH="/qlogic/home/5125/astiles/perl5/bin:$PATH";

if [ -f /etc/bash_completion ]; then source /etc/bash_completion; fi
