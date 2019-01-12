TARGET	= libmatmult.so
LIBSRCS	= matmult.c
LIBOBJS	=  $(LIBSRCS:.c=.o)

OPT	= -g $(COMPILER_OPTIONS)
PIC	= -fPIC

CC	= gcc
CFLAGS= $(OPT) $(PIC) $(XOPTS)

SOFLAGS = -shared
XLIBS	=

$(TARGET): $(LIBOBJS)
	$(CC) -o $@ $(SOFLAGS) $(LIBOBJS) $(XLIBS)

clean:
	@/bin/rm -f core core.* $(LIBOBJS)


run:
	make && ./matmult_c.gcc lib 1000 1000 1000
