SRCS	= main.c datatools.c jacobi.c gauss.c
OBJS	= $(SRCS:.c=.o)
TARGET	= jacob_gauss.$(CC)

CC	= suncc
INCS	= 
DBG	= -g
OPT	= -O3 -fast -xrestrict
PARA	= -xopenmp
CFLAGS	= $(DBG) $(OPT) $(PARA) $(XOPTS)

LIBS	= 

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	@/bin/rm -f $(OBJS) *~ core*

realclean: clean
	@/bin/rm -f $(TARGET)
