if [ -z $BASHRC_LOADED ]; then
    export BASHRC_LOADED=1
    PATH=$HOME/scripts:$PATH:$HOME/bin
    export PATH;
fi

export PKG_CONFIG_PATH="/usr/lib/pkgconfig"

export CVSEDITOR=/usr/bin/vim
export CVSROOT=:ext:astiles@kop-sds-repos.qlogic.org:/cvs
export CVS_RSH=/usr/bin/ssh

export BROWSER=/usr/bin/google-chrome

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
