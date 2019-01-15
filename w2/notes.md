## Sync to remote mount
>Note: Needs testing
```bash
open 'smb://home.cc.dtu.dk/s144222'
# try
# man mount_smbfs
# do all the ui ish

rsync --progress -rt --delete Documents/DTU/Semester\ 10/02614\ -\ High\ Performance\ Computing/HPC /Volumes/s144222/Documents/
```


## Makefile with multithreading and time check

```makefile
CC  := gcc
C_FLAGS := -Wall -Wextra

OMP_FLAGS := -floop-parallelize-all -fopenmp
SUN_FLAGS := #-c -g -fast -xrestrict -xautopar -xloopinfo
N_THREADS := 4
THREAD_FLAGS := OMP_NUM_THREADS=$(N_THREADS) /bin/time -v


BIN  := bin
SRC  := src
INCLUDE := include
LIB  := lib

LIBRARIES :=

EXECUTABLE := main

all: $(BIN)/$(EXECUTABLE)

clean:
	-$(RM) $(BIN)/$(EXECUTABLE)

run: all
	#./$(BIN)/$(EXECUTABLE)
	$(THREAD_FLAGS) ./$(BIN)/$(EXECUTABLE)

$(BIN)/$(EXECUTABLE): $(SRC)/*
	$(CC) $(C_FLAGS) -I$(INCLUDE) -L$(LIB) $^ -o $@ $(LIBRARIES) $(SUNOPTS) $(OMP_FLAGS)
```
