SRCS	= main.c datatools.c matadd.c
OBJS	= $(SRCS:.c=.o)
TARGET	= madd.$(CC)

CC	= gcc
INCS	=
DBG	= -g
OPT	= -Ofast
PARA	=
CFLAGS	= $(DBG) $(OPT) $(PARA) $(XOPTS)

LIBS	=

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LIBS)

run: all
	./$(TARGET)

clean:
	@/bin/rm -f $(OBJS) *~ core*

realclean: clean
	@/bin/rm -f $(TARGET)
