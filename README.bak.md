# HPC
Repo for HPC course at DTU

Piazza Link: https://piazza.com/class/jpwofdl793d7dd?cid=6
Coursebase Link: http://kurser.dtu.dk/course/02614

## Week 3

### Using the GPU cluster

```bash
# request interactive GPU node
hpcintrogpush

# load dependencies
module load cuda/10.0
module load gcc/7.3.0

# see processes running on node's GPUs
nvidia-smi

# See GPUs details
/appl/cuda/10.0/samples/bin/x86_64/linux/release/deviceQuery

# see CPU details
lscpu

# see memory on CPUs
free


```


## Week 1 & 2

### Submit file to jobqueue

```bash
$ cat submit.sh
#!/bin/bash
#BSUB -J sleeper
#BSUB -o sleeper_%J.out
#BSUB -e sleeper_%J.err
#BSUB -q hpcintro
#BSUB -W 2 -R "rusage[mem=5012MB]"

rm nonex.txt
echo "30 sec"
sleep 30
```
[More about jobqueue](https://www.hpc.dtu.dk/?page_id=1416)

```bash
bsub < submit.sh # submit job in sumbit.sh to jobqueue
bsub -N < submit.sh #notify by email when done
bjobs # time elapsed
bstat # time remaining
```

### Running without makefile
somefile.c has the following code:
```c
#include <stdio.h>
main() {
  printf("Hello World\n");
}
```

To compile and run the file without a makefile:

```bash
$ gcc -o somefile somefile.c
$ ./somefile
$ rm somefile
```

Can also be done in one line:
```bash
$ gcc -o somefile somefile.c && ./somefile && rm somefile
```

Makefile oneline
```bash
make clean ; make ; ./bin/jacob_gauss.gcc-8
```

### Running

Make sure the makefile is right!

```bash
cd HPC/w1/d1/ex1_4 # go to directory with makefile
ls # ensure makefile, src and bin are present
make run # compile src files and run them
```
