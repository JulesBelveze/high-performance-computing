CC  := gcc
C_FLAGS := -Wall -Wextra

MY_ARGS := poisson 10 20 30

BIN  := bin
SRC  := src
INCLUDE := include
LIB  := lib

EXECUTABLE := main

all: $(BIN)/$(EXECUTABLE)

clean:
	-$(RM) $(BIN)/$(EXECUTABLE)

run: all
	#./$(BIN)/$(EXECUTABLE)
	./$(BIN)/$(EXECUTABLE) $(MY_ARGS)

$(BIN)/$(EXECUTABLE): $(SRC)/*
	$(CC) $(C_FLAGS) -I$(INCLUDE) -L$(LIB) $^ -o $@
