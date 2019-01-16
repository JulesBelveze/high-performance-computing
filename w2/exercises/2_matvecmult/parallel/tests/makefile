CC = gcc
PROGRAM2 = mxv
CFLAGS = -floop-parallelize-all -fopenmp

mxv: mxv.o
	$(CC) $(CFLAGS) -o mxv mxv.o

.PHONY: clean
clean:
	@rm -f $(PROGRAM1) *.o core
	@rm -f $(PROGRAM2) *.o core
