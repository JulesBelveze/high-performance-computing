

# Check if done
# ssh -tt HPCintro << EOT
# 	export TERM=xterm
# 	linuxsh
# 	bstat
# EOT

# ssh -tt HPCintro 'linuxsh; bstat'
# "bash -ic ll"


ssh -tt HPCintro bash -ic "shopt -s expand_aliases; [ -z "$PS1" ] && linuxsh; sleep 1; bstat"

# ssh -tt HPCintro bash -ic "/lsf/local/bin/linuxsh; sleep 1; bstat"
