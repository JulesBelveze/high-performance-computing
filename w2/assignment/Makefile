SRCS	= main.c datatools.c jacobi.c gauss.c
OBJS	= $(SRCS:.c=.o)
TARGET	= jacob_gauss.$(CC)

CC	=  gcc#suncc
INCS	=
DBG	= -g
# OPT	= -O3 -fast -xrestrict
# PARA	= -xopenmp
OPT	= -Ofast
CFLAGS	= $(DBG) $(OPT) $(PARA) $(XOPTS)

LIBS	=

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	@/bin/rm -f $(OBJS) *~ core*

realclean: clean
	@/bin/rm -f $(TARGET)
