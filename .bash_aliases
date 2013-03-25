# WARNING.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Only use this file to define aliases or functions for
# the bash
# 
# Never do any 'export' in this .bash_aliases file.
# 'exports' are to be defined in the ${HOME}/.myprofile file only
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ATTENTION.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Ne definissez dans ce fichier que des alias ou fonctions 
# pour le bash.
#
# Ne faites jamais de 'export' dans votre .bash_aliases.
# Vos 'export' particuliers doivent etre définis dans votre
# fichier ${HOME}/.myprofile
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# These are alias examples...
# Just remove the '#' to make them available
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Ceci sont des exemples, retirez le '#' 
# pour les prendre en compte
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#	unalias ls
#	unalias rm
#
#	alias l="ls -l"
#	alias ll="ls -la"
#	alias rmo="rm *.o"
#	alias rm#="rm .*~ *~ core"

# Nom fenetre xterm + icone
# ~~~~~~~~~~~~~~~~~~~~~~~~~
# xn()
# {
# echo "\\033]0;$*\\007\\c"
# }
#LTE_ENB_OAM_DESIGN_BEGIN
[ -f /net/pluto/vol/vol7/lte_oam_rep/oam_profile/profile/bash_aliases ] && source /net/pluto/vol/vol7/lte_oam_rep/oam_profile/profile/bash_aliases
#LTE_ENB_OAM_DESIGN_END

alias l="ls -l"
alias ll="ls -la"
alias rmo="rm *.o"
alias rm#="rm .*~ *~ core"

alias ltr="ls -ltr"

alias     grep='grep --colour=tty --binary-files=text'
alias        h='history 25'
alias    kdiff='kdiff3'
alias       ls='ls --color=tty '
alias        l='ls -CF --color=tty '
alias       l.='ls .[a-zA-Z]* --color=tty -d'
alias       ll='ls -l --color=tty '
alias      ltr='ls -ltr --color=tty '
alias       pu='ps -fu $USER'

alias vi=vim
alias A='head'
alias C='sort -f|uniq -c'
alias G='egrep'
alias I='column'
alias M='less'
alias S='sort -f'
alias S0='sort -n'
alias Z='tail'
alias c=cat
alias d='date -I'

alias cdoam='cd /vobs/lte_oam_ucm/lte_oam/tools/scripts/'
alias cdhost='cd /vobs/lte_oam_ucm/lte_oam/tools/hosttest'
alias ctsvmca13.3="SHELL=/bin/csh /opt/rational/clearcase/bin/cleartool setview ${USER}_oam_lr13l_metro_tm_dev"
alias killOamTest='cd /vobs/lte_oam_ucm/lte_oam/tools/hosttest; ./killOamTest; cd -'
alias bcsOamTest='cd /vobs/lte_oam_ucm/lte_oam/tools/hosttest; ./bcsOamTest -sF -r 2>&1 | tee /tmp/log`date +%m-%d_%I:%m`.log; cd -'

alias rsatre85="/opt/swe/tools/ext/rational/rsarte-8.5.1/i686-linux2.6/SDP/rsarte_eclipse"
alias sclish="/vobs/onepltf_ltefdd/delivery/mw/hostExe/sCliSh -t $USER"
alias confd_cli=" /vobs/lte_third_party/confd/x86/bin/confd_cli --noaaa --user system"

alias ctsvmca13.3="SHELL=/bin/bash /opt/rational/clearcase/bin/cleartool setview ${USER}_oam_lr13l_metro_tm_dev"

alias confd-console='cd $HOME/libs/netconf; ./confd-console.exp mrclte182 8830 initial_snm'
alias snmp-get="snmpget -v3 -a SHA -l authNoPriv -u initial_snm -A '@t9n;_EBQb' -t 5 -mENB-MIB -M$HOME/libs/ENB-MIB-07v10 localhost:8161"
alias snmp-walk="snmpwalk -Cc -v3 -a SHA -l authNoPriv -u initial_snm -A '@t9n;_EBQb' -t 5 -mENB-MIB -M$HOME/libs/ENB-MIB-07v10 localhost:8161"


PS1='${debian_chroot:+($debian_chroot)}\u@\h: \w
$ '

export PS1
