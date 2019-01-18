# PUSH TO HPC
rsync -avz --delete -e ssh ~/Documents/DTU/Semester\ 10/02614\ -\ High\ Performance\ Computing/HPC/ HPCintro://zhome/ff/a/97945/Documents/HPC

# RUN TASKS
ssh -tt HPCintro << EOT
	export TERM=xterm
	linuxsh
	cd Documents/HPC/w2/assignment/
	bsub < perf_2_runtime.sh
	sleep 0.1
	exit
	exit
EOT

# PULL FROM HPCintro
# rsync -avz --delete -e ssh HPCintro://zhome/ff/a/97945/Documents/HPC/ ~/Documents/DTU/Semester\ 10/02614\ -\ High\ Performance\ Computing/HPC 
